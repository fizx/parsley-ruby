#include "ruby.h"
#include <stdio.h>
#include <libxslt/xslt.h>
#include <libexslt/exslt.h>
#include <libxslt/xsltInternals.h>
#include <libxslt/transform.h>
#include <libxml/parser.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xmlwriter.h>
#include <parsley.h>
#include <json/json.h>
#include <xml2json.h>

VALUE _new(VALUE, VALUE, VALUE);
VALUE _parse(VALUE, VALUE);
VALUE _rb_set_user_agent(VALUE self, VALUE agent);
VALUE c_parsley_err;
VALUE c_parsley;

void Init_cparsley()
{
	c_parsley = rb_define_class("CParsley", rb_cObject);
	c_parsley_err = rb_define_class("ParsleyError", rb_eRuntimeError);
	rb_define_singleton_method(c_parsley, "new", _new, 2);
	rb_define_singleton_method(c_parsley, "set_user_agent", _rb_set_user_agent, 1);
	rb_define_method(c_parsley, "parse", _parse, 1);
}

VALUE 
_new(VALUE self, VALUE parsley, VALUE incl){
	parsleyPtr ptr = parsley_compile(STR2CSTR(parsley), STR2CSTR(incl));
	if(ptr->error != NULL) {
	  rb_raise(c_parsley_err, ptr->error);
    parsley_free(ptr);
    return Qnil;
	}
	
 	return Data_Wrap_Struct(c_parsley, 0, parsley_free, ptr);
}

VALUE 
_rb_set_user_agent(VALUE self, VALUE agent) {
  parsley_set_user_agent(STR2CSTR(agent));
  return Qtrue;
}


static VALUE 
rubify_recurse(xmlNodePtr xml) {
  if(xml == NULL) return NULL;
  xmlNodePtr child;
  VALUE obj = Qnil;

  switch(xml->type) {
    case XML_ELEMENT_NODE:
      child = xml->children;
      if(xml->ns == NULL) {
        child = xml;
        obj = rb_hash_new();
        while(child != NULL) {
          rb_hash_aset(obj, rb_str_new2(child->name), rubify_recurse(child->children));
          child = child->next;
        }
      } else if(!strcmp(xml->ns->prefix, "parsley")) {
        if(!strcmp(xml->name, "groups")) {
          obj = rb_ary_new();
          while(child != NULL) {
            rb_ary_push(obj, rubify_recurse(child->children));
            child = child->next;
          }          
        } else if(!strcmp(xml->name, "group")) {
          // Implicitly handled by parsley:groups handler
        }
      }
      break;
    case XML_TEXT_NODE:
      obj = rb_str_new2(xml->content);
      break;
  }
  // inspect(obj);
  return obj;
}

static VALUE 
_parse_doc(parsedParsleyPtr ptr, VALUE type) {
	if(ptr->error != NULL || ptr->xml == NULL) {
    if(ptr->error == NULL) ptr->error = strdup("Unknown parsley error");
		rb_raise(c_parsley_err, ptr->error);
    parsed_parsley_free(ptr);
		return Qnil;
	}
	
	VALUE output;
	if(type == ID2SYM(rb_intern("json"))) {
		struct json_object *json = xml2json(ptr->xml->children->children);
		char* str = json_object_to_json_string(json);
		output = rb_str_new2(str);
		json_object_put(json);
	} else if(type == ID2SYM(rb_intern("xml"))) {
		xmlChar* str;
		int size;
		xmlDocDumpMemory(ptr->xml, &str, &size);
		output = rb_str_new(str, size);
	} else {
 		output = rubify_recurse(ptr->xml->children->children);
		if((void*)output == NULL) output = Qnil; 
	}
	
  parsed_parsley_free(ptr);
  
	return output;
}

#define OPT(A) rb_hash_aref(options, ID2SYM(rb_intern(A)))
#define OPT_BOOL(A) (OPT(A) != Qnil && OPT(A) != Qfalse)
#define OPT_MATCH(A, B) (rb_hash_aref(options, ID2SYM(rb_intern(A))) == ID2SYM(rb_intern(B)))

VALUE _parse(VALUE self, VALUE options){
	parsleyPtr parsley;
	Data_Get_Struct(self, parsleyPtr, parsley);
  int flags = 0;
  char *base = NULL;
  if(OPT_MATCH("input", "html"))    flags |= PARSLEY_OPTIONS_HTML;
  if(OPT_BOOL("prune"))             flags |= PARSLEY_OPTIONS_PRUNE;
  if(OPT_BOOL("collate"))           flags |= PARSLEY_OPTIONS_COLLATE;
  if(OPT_BOOL("allow_net"))         flags |= PARSLEY_OPTIONS_ALLOW_NET;
  if(OPT_BOOL("allow_local"))       flags |= PARSLEY_OPTIONS_ALLOW_LOCAL;
  if(OPT_BOOL("sgwrap"))            flags |= PARSLEY_OPTIONS_SGWRAP;
  if(OPT_BOOL("has_base"))          base = STR2CSTR(OPT("base"));
  
  // printf("prune: %d\nallow_net: %d\nallow_local: %d\nhas_base: %d\nflags: %d\n", OPT_BOOL("prune"), OPT_BOOL("allow_net"), OPT_BOOL("allow_local"), OPT_BOOL("has_base"), flags);
  
  if(OPT_BOOL("is_file")) {
    return _parse_doc(parsley_parse_file(parsley, STR2CSTR(OPT("file")), flags), OPT("output"));
  } else {
    char * str = STR2CSTR(OPT("string"));
    return _parse_doc(parsley_parse_string(parsley, str, strlen(str), base, flags), OPT("output"));
  }
}