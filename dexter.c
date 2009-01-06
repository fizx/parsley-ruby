#include <stdio.h>
#include <stdlib.h>
#include <argp.h>
#include <json/json.h>
#include "kstring.h"
#include "dexter.h"
#include "y.tab.h"
#include "printbuf.h"
#include "functions.h"
#include "util.h"
#include <string.h>
#include <errno.h>
#include <ctype.h>
#include <stdbool.h>
#include <libxslt/xslt.h>
#include <libxslt/xsltInternals.h>
#include <libxslt/transform.h>
#include <libxml/parser.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xmlwriter.h>
#include <libexslt/exslt.h>

int yywrap(void){
  return 1;
}

xmlDocPtr dex_parse_file(dexPtr dex, char* file, boolean html) {
	if(html) {
		htmlParserCtxtPtr htmlCtxt = htmlNewParserCtxt();
  	htmlDocPtr html = htmlCtxtReadFile(htmlCtxt, file, NULL, HTML_PARSE_RECOVER | HTML_PARSE_NOERROR |HTML_PARSE_NOWARNING);
		if(html == NULL) {
			asprintf(&dex->error, "Couldn't parse file: %s\n", file);
			return NULL;
		}
		return dex_parse_doc(dex, html);
	} else {
		xmlParserCtxtPtr ctxt = xmlNewParserCtxt();
		xmlDocPtr xml = xmlCtxtReadFile(ctxt, file, NULL, HTML_PARSE_RECOVER | HTML_PARSE_NOERROR |HTML_PARSE_NOWARNING);
		if(xml == NULL) {
			asprintf(&dex->error, "Couldn't parse file: %s\n", file);
			return NULL;
		}
		return dex_parse_doc(dex, xml);
	}
}

xmlDocPtr dex_parse_string(dexPtr dex, char* string, size_t size, boolean html) {
	if(html) {
		htmlParserCtxtPtr htmlCtxt = htmlNewParserCtxt();
  	htmlDocPtr html = htmlCtxtReadMemory(htmlCtxt, string, size, "http://kylemaxwell.com/dexter/memory", NULL, HTML_PARSE_RECOVER | HTML_PARSE_NOERROR |HTML_PARSE_NOWARNING);
		if(html == NULL) {
			asprintf(&dex->error, "Couldn't parse string\n");
			return NULL;
		}
		return dex_parse_doc(dex, html);
	} else {
		xmlParserCtxtPtr ctxt = xmlNewParserCtxt();
 		xmlDocPtr xml = xmlCtxtReadMemory(ctxt, string, size, "http://kylemaxwell.com/dexter/memory", NULL, HTML_PARSE_RECOVER | HTML_PARSE_NOERROR |HTML_PARSE_NOWARNING);
		if(xml == NULL) {
			asprintf(&dex->error, "Couldn't parse string\n");
			return NULL;
		}
		return dex_parse_doc(dex, xml);
	}
}

xmlDocPtr dex_parse_doc(dexPtr dex, xmlDocPtr doc) {
	return xsltApplyStylesheet(dex->stylesheet, doc, NULL);
}

dexPtr dex_compile(char* dex_str, char* incl) {
	dexPtr dex = (dexPtr) calloc(sizeof(compiled_dex), 1);
	
	if(last_dex_error != NULL) {
		free(last_dex_error);
		last_dex_error = NULL;
	}
	
  if(!dex_exslt_registered) {
    exsltRegisterAll();
		dex_register_all();
		init_xpath_alias();
		exslt_org_regular_expressions_init();
    dex_exslt_registered = true;
  }
	
	struct json_object *json = json_tokener_parse(dex_str);
	if(is_error(json)) {
		dex->error = strdup("Your dex is not valid json.");
		return dex;
	}

	struct printbuf* buf = printbuf_new();
	
  sprintbuf_dex_header(buf);
	sprintbuf(buf, "%s\n", incl);
	sprintbuf(buf, "<xsl:template match=\"/\">\n");
	sprintbuf(buf, "<dexter:root>\n");
		
	contextPtr context = new_context(json, buf);
	__dex_recurse(context);
	
	json_object_put(json); // frees json
	dex->error = last_dex_error;
	
	sprintbuf(buf, "</dexter:root>\n");
	sprintbuf(buf, "</xsl:template>\n");
	sprintbuf(buf, context->key_buf->buf);
	sprintbuf(buf, "</xsl:stylesheet>\n");
	
	if(dex->error == NULL) {
		xmlParserCtxtPtr ctxt = xmlNewParserCtxt();
		xmlDocPtr doc = xmlCtxtReadMemory(ctxt, buf->buf, buf->size, "http://kylemaxwell.com/dexter/compiled", NULL, 3);
		dex->raw_stylesheet = strdup(buf->buf);
		dex->stylesheet = xsltParseStylesheetDoc(doc);
	}
	
	printbuf_free(buf);
	dex_collect();
	
	return dex;
}

static contextPtr new_context(struct json_object * json, struct printbuf *buf) {
	contextPtr c = dex_alloc(sizeof(dex_context));
	c->key_buf = printbuf_new();
	sprintbuf(c->key_buf, "");
	c->name = "root";
	c->tag = "root";
	c->full_expr = "/";
	c->expr = NULL;
	c->magic = NULL;
	c->filter = NULL;
	c->buf = buf;
	c->json = json;
	c->parent = NULL;
	c->array = 0;
	c->string = 0;
	c->keys = NULL;
	return c;
}

contextPtr deeper_context(contextPtr context, char* key, struct json_object * val) {
	// printf("1\n");
	contextPtr c = dex_alloc(sizeof(dex_context));
	c->key_buf = context->key_buf;
	c->keys = context->keys;
	c->tag = dex_key_tag(key);
	c->name = astrcat3(context->name, ".", c->tag);
	dex_parsing_context = c;
	
	// printf("4\n");
	c->array = json_object_is_type(val, json_type_array);
	c->json = c->array ? json_object_array_get_idx(val, 0) : val;
	c->string = json_object_is_type(c->json, json_type_string);
	c->filter = dex_key_filter(key);
	
	c->magic = ((c->filter == NULL) && c->array && !(c->string)) ? c->name : context->magic;
	if(context->filter != NULL && !c->array) c->magic = NULL;
	c->buf = context->buf;
	// printf("%d\n", c->string);
	c->raw_expr = c->string ? myparse(astrdup(json_object_get_string(c->json))) : NULL;
	
	// printf("5\n");
	c->full_expr = full_expr(context, c->filter);
	c->full_expr = full_expr(c, c->raw_expr);
	
	c->expr = filter_intersection(c->magic, c->raw_expr);
	c->filter = filter_intersection(c->magic, c->filter);
	c->parent = context;
	// printf("2\n");
	return c;
}

static char* filter_intersection(char* key, char* expr) {
	if(key != NULL && expr != NULL) {
		return astrcat7("set:intersection(key('", key, "__key', $", key, "__index), ", expr, ")");
	} else {
		return expr;
	}
}

void dex_free(dexPtr ptr) {
	if(ptr->error != NULL) 						
			free(ptr->error);
	if(ptr->raw_stylesheet != NULL)
			free(ptr->raw_stylesheet);
	if(ptr->stylesheet != NULL) 			
			xsltFreeStylesheet(ptr->stylesheet);
	free(ptr);
}

void yyerror(const char * s) {
	struct printbuf *buf = printbuf_new();
	if(last_dex_error !=NULL) sprintbuf(buf, "%s\n", last_dex_error);
  sprintbuf(buf, "%s in key: %s", s, dex_parsing_context->name);
	last_dex_error = strdup(buf->buf);
	printbuf_free(buf);
}

static int dex_key_flags(char* key) {
  char* ptr = key;
  char* last_alnum;
  char* last_paren;
  while(*ptr++ != '\0'){
    if(isalnum(*ptr)) {
      last_alnum = ptr;
    } else if (*ptr == ')') {
      last_paren = ptr;
    }
  }
  ptr = (last_alnum > last_paren ? last_alnum : last_paren) + 1;
  int flags = 0;
  while(*ptr++ != '\0'){
    switch(*ptr){
    case '?':
      flags |= DEX_OPTIONAL;
      break;
    }
  }
  return flags;
}

char* dex_key_tag(char* key) {
	char *tag = astrdup(key);
	char *ptr = tag;
	while(*ptr++ != '\0'){
		if(!isalnum(*ptr) && *ptr != '_' && *ptr != '-') {
			*ptr = 0;
			return tag;
		}
	}
	return tag;
}

char* dex_key_filter(char* key) {
	char *expr = astrdup(key);
	char *ptr = expr;
  char *last_paren;

	int offset = 0;
	bool has_expr = false;

	while(*ptr++ != '\0'){
		if(!has_expr)     offset++;
		if(*ptr == '(')   has_expr = true;
    if(*ptr == ')')   last_paren = ptr;
	}
	if(!has_expr) return NULL;
  *last_paren = 0; // clip ")"
	expr += offset + 1; // clip "("
  
	return strlen(expr) == 0 ? NULL : myparse(expr);
}

void __dex_recurse(contextPtr context) {
	// printf("a\n");
	char* tmp;
	struct printbuf * buf;
	keyPtr keys;
	contextPtr c;
	json_object_object_foreach(context->json, key, val) {
		c = deeper_context(context, key, val);
		sprintbuf(c->buf, "<%s>\n", c->tag);	
		if(c->string) {
			if(c->array) {
				if(c->filter){
					sprintbuf(c->buf, "<dexter:groups><xsl:for-each select=\"%s\"><dexter:group>\n", c->filter);	
					sprintbuf(c->buf, "<xsl:value-of select=\"%s\" />\n", c->raw_expr);
					sprintbuf(c->buf, "</dexter:group></xsl:for-each></dexter:groups>\n");
				} else {
					sprintbuf(c->buf, "<dexter:groups><xsl:for-each select=\"%s\"><dexter:group>\n", c->expr);	
					sprintbuf(c->buf, "<xsl:value-of select=\".\" />\n");
					sprintbuf(c->buf, "</dexter:group></xsl:for-each></dexter:groups>\n");
				}
			} else {
				if(c->filter){
					sprintbuf(c->buf, "<xsl:for-each select=\"%s\"><xsl:if test=\"position()=1\">\n", c->filter);	
					sprintbuf(c->buf, "<xsl:value-of select=\"%s\" />\n", c->raw_expr);
					sprintbuf(c->buf, "</xsl:if></xsl:for-each>\n");
				} else {
					sprintbuf(c->buf, "<xsl:value-of select=\"%s\" />\n", c->expr);
				}
			} 
		} else { // if c->object !string
			if(c->array) {		// scoped

				if(c->filter != NULL) {
					
					// printf("e\n");
					sprintbuf(c->buf, "<dexter:groups><xsl:for-each select=\"%s\"><dexter:group>\n", c->filter);	
					__dex_recurse(c);
					sprintbuf(c->buf, "</dexter:group></xsl:for-each></dexter:groups>\n");
				} else {				// magic	
					
					// printf("f\n");
					sprintbuf(c->buf, "<xsl:variable name=\"%s__context\" select=\".\"/>\n", c->name);
					dex_parsing_context = c;
					tmp = myparse(astrdup(inner_key_of(c->json)));
					if(tmp == NULL) {
						
					}
					sprintbuf(c->buf, "<dexter:groups><xsl:for-each select=\"%s\">\n", filter_intersection(context->magic, tmp));	


					// keys
					keys = dex_alloc(sizeof(key_node));
					keys->name = c->name;
					keys->use = full_expr(c, tmp);
					keys->next = c->keys;
					c->keys = keys;
					
					buf = printbuf_new();
					
					sprintbuf(buf, "concat(");
					while(keys != NULL){
						sprintbuf(buf, "count(set:intersection(following::*, %s)), '-',", keys->use);
						keys = keys->next;
					}
					sprintbuf(buf, "'')");
					tmp = astrdup(buf->buf);
					printbuf_free(buf);
					
					sprintbuf(c->key_buf, "<xsl:key name=\"%s__key\" match=\"%s\" use=\"%s\"/>\n", c->name, 
						full_expr(c, "./descendant-or-self::*"),
						tmp
					);

					sprintbuf(c->buf, "<xsl:variable name=\"%s__index\" select=\"%s\"/>\n", c->name, tmp);
					sprintbuf(c->buf, "<xsl:for-each select=\"$%s__context\"><dexter:group>\n", c->name);	
					__dex_recurse(c);
					sprintbuf(c->buf, "</dexter:group></xsl:for-each></xsl:for-each></dexter:groups>\n");					
				}
			} else {
				
				// printf("c\n");
				if(c->filter == NULL) {
					__dex_recurse(c);
				} else {	
					sprintbuf(c->buf, "<xsl:for-each select=\"%s\"><xsl:if test=\"position() = 1\">\n", c->filter);	
					__dex_recurse(c);
					sprintbuf(c->buf, "</xsl:if></xsl:for-each>\n");
				}
			}
		}
		sprintbuf(c->buf, "</%s>\n", c->tag);
	}
}

static char* full_expr(contextPtr context, char* expr) {
	if(expr == NULL) return context->full_expr;
	char* merged = arepl(expr, ".", context->full_expr);
	return arepl(merged, "///", "//");
}

static char* inner_key_of(struct json_object * json) {
	switch(json_object_get_type(json)) {
		case json_type_string: 
			return json_object_get_string(json);
		case json_type_array:
			return NULL;
		case json_type_object:
			return inner_key_each(json);
	}
}

static char* inner_key_each(struct json_object * json) {
	json_object_object_foreach(json, key, val) {
		char* inner = inner_key_of(val);
		if(inner != NULL) return inner;
	}
	return NULL;
}
