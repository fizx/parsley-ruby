#!/usr/bin/env ruby
# ENV["ARCHFLAGS"] ||= "-arch #{`uname -p` =~ /powerpc/ ? 'ppc' : 'i386'}"

require 'mkmf'

EXT = File.expand_path(File.dirname(__FILE__))

LIBDIR = Config::CONFIG['libdir']
INCLUDEDIR = Config::CONFIG['includedir']

system "cd #{EXT}/parsley && ./configure && make"

$CFLAGS << " -g -DXP_UNIX"
$CFLAGS << " -O3 -Wall -Wextra -Wcast-qual -Wwrite-strings -Wconversion -Wmissing-noreturn -Winline"

find_library('xml2', 'xmlParseDoc', LIBDIR) or abort "need -lxml2"
find_library('xslt', 'xsltParseStylesheetDoc', LIBDIR) or abort "need -lxslt"
find_header('libxml/xmlversion.h', File.join(INCLUDEDIR, "libxml2")) or abort "need libxml headers"
find_header('libxslt/xslt.h', INCLUDEDIR) or abort "need libxslt headers"
find_header('ruby.h', INCLUDEDIR) or abort "need ruby.h"

find_header("#{EXT}/parsley/json-c-0.9/json.h", INCLUDEDIR) or abort "need json/json.h"
find_library("json", "json_object_new_string", "#{EXT}/parsley/json-c-0.9/") or abort "need libjson"

find_header("#{EXT}/parsley/parsley.h", INCLUDEDIR) or abort "need parsley.h"
find_library('parsley', 'parsley_compile', "#{EXT}/parsley/") or abort "need libparsley"

create_makefile('cparsley')