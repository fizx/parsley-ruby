#!/usr/bin/env ruby
# ENV["ARCHFLAGS"] ||= "-arch #{`uname -p` =~ /powerpc/ ? 'ppc' : 'i386'}"

require 'mkmf'

EXT = File.expand_path(File.dirname(__FILE__))

LIBDIR = Config::CONFIG['libdir']
INCLUDEDIR = Config::CONFIG['includedir']

system "cd #{EXT}/parsley && ./configure && make"

$CFLAGS << " -g -DXP_UNIX"
$CFLAGS << " -O3 -Wall -Wextra -Wcast-qual -Wwrite-strings -Wconversion -Wmissing-noreturn -Winline"


if Config::CONFIG['target_os'] =~ /mswin32/
  lib_prefix = 'lib'

  # There's no default include/lib dir on Windows. Let's just add the Ruby ones
  # and resort on the search path specified by INCLUDE and LIB environment
  # variables
  HEADER_DIRS = [INCLUDEDIR]
  LIB_DIRS = [LIBDIR]
  XML2_HEADER_DIRS = [File.join(INCLUDEDIR, "libxml2"), INCLUDEDIR]

else
  lib_prefix = ''

  HEADER_DIRS = [
    # First search /opt/local for macports
    '/opt/local/include',

    # Then search /usr/local for people that installed from source
    '/usr/local/include',

    # Check the ruby install locations
    INCLUDEDIR,

    # Finally fall back to /usr
    '/usr/include',
    '/usr/include/libxml2',
  ]

  LIB_DIRS = [
    # First search /opt/local for macports
    '/opt/local/lib',

    # Then search /usr/local for people that installed from source
    '/usr/local/lib',

    # Check the ruby install locations
    LIBDIR,

    # Finally fall back to /usr
    '/usr/lib',
  ]

  XML2_HEADER_DIRS = [
    '/opt/local/include/libxml2',
    '/usr/local/include/libxml2',
    File.join(INCLUDEDIR, "libxml2")
  ] + HEADER_DIRS
end

dir_config('xml2', XML2_HEADER_DIRS, LIB_DIRS)
dir_config('xslt', HEADER_DIRS, LIB_DIRS)

find_library("#{lib_prefix}xml2", 'xmlParseDoc') or abort "need -lxml2"
find_library("#{lib_prefix}xslt", 'xsltParseStylesheetDoc') or abort "need -lxslt"
find_header('libxml/xmlversion.h') or abort "need libxml headers"
find_header('libxslt/xslt.h') or abort "need libxslt headers"
find_header('ruby.h', INCLUDEDIR) or abort "need ruby.h"

find_header("#{EXT}/parsley/json-c-0.9/json.h", INCLUDEDIR) or abort "need json/json.h"
find_library("#{lib_prefix}json", "json_object_new_string", "#{EXT}/parsley/json-c-0.9/") or abort "need libjson"

find_header("#{EXT}/parsley/parsley.h", INCLUDEDIR) or abort "need parsley.h"
find_library("#{lib_prefix}parsley", 'parsley_compile', "#{EXT}/parsley/") or abort "need libparsley"

create_makefile('cparsley')

