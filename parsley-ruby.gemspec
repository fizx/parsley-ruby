# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{parsley-ruby}
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kyle Maxwell"]
  s.date = %q{2010-01-14}
  s.description = %q{XML/HTML Parser}
  s.email = %q{kyle@kylemaxwell.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG",
     "README",
     "Rakefile",
     "VERSION",
     "ext/cparsley.c",
     "ext/extconf.rb",
     "ext/parsley/.gitignore",
     "ext/parsley/AUTHORS",
     "ext/parsley/ChangeLog",
     "ext/parsley/HACKING",
     "ext/parsley/INSTALL",
     "ext/parsley/INTRO",
     "ext/parsley/Makefile.am",
     "ext/parsley/Makefile.in",
     "ext/parsley/NEWS",
     "ext/parsley/PAPER",
     "ext/parsley/Portfile",
     "ext/parsley/Portfile.in",
     "ext/parsley/README.C-LANG",
     "ext/parsley/README.markdown",
     "ext/parsley/TODO",
     "ext/parsley/VERSION",
     "ext/parsley/aclocal.m4",
     "ext/parsley/bootstrap.sh",
     "ext/parsley/config.guess",
     "ext/parsley/config.sub",
     "ext/parsley/configure",
     "ext/parsley/configure.ac",
     "ext/parsley/depcomp",
     "ext/parsley/functions.c",
     "ext/parsley/functions.h",
     "ext/parsley/generate_bisect.sh",
     "ext/parsley/hooks/prepare-commit-msg",
     "ext/parsley/install-sh",
     "ext/parsley/json-c-0.9/AUTHORS",
     "ext/parsley/json-c-0.9/COPYING",
     "ext/parsley/json-c-0.9/ChangeLog",
     "ext/parsley/json-c-0.9/INSTALL",
     "ext/parsley/json-c-0.9/Makefile.am",
     "ext/parsley/json-c-0.9/Makefile.in",
     "ext/parsley/json-c-0.9/NEWS",
     "ext/parsley/json-c-0.9/README",
     "ext/parsley/json-c-0.9/README-WIN32.html",
     "ext/parsley/json-c-0.9/README.html",
     "ext/parsley/json-c-0.9/aclocal.m4",
     "ext/parsley/json-c-0.9/arraylist.c",
     "ext/parsley/json-c-0.9/arraylist.h",
     "ext/parsley/json-c-0.9/bits.h",
     "ext/parsley/json-c-0.9/config.guess",
     "ext/parsley/json-c-0.9/config.h",
     "ext/parsley/json-c-0.9/config.h.in",
     "ext/parsley/json-c-0.9/config.h.win32",
     "ext/parsley/json-c-0.9/config.sub",
     "ext/parsley/json-c-0.9/configure",
     "ext/parsley/json-c-0.9/configure.in",
     "ext/parsley/json-c-0.9/debug.c",
     "ext/parsley/json-c-0.9/debug.h",
     "ext/parsley/json-c-0.9/depcomp",
     "ext/parsley/json-c-0.9/doc/html/annotated.html",
     "ext/parsley/json-c-0.9/doc/html/arraylist_8h.html",
     "ext/parsley/json-c-0.9/doc/html/bits_8h.html",
     "ext/parsley/json-c-0.9/doc/html/classes.html",
     "ext/parsley/json-c-0.9/doc/html/config_8h.html",
     "ext/parsley/json-c-0.9/doc/html/debug_8h.html",
     "ext/parsley/json-c-0.9/doc/html/doxygen.css",
     "ext/parsley/json-c-0.9/doc/html/doxygen.png",
     "ext/parsley/json-c-0.9/doc/html/files.html",
     "ext/parsley/json-c-0.9/doc/html/functions.html",
     "ext/parsley/json-c-0.9/doc/html/functions_vars.html",
     "ext/parsley/json-c-0.9/doc/html/globals.html",
     "ext/parsley/json-c-0.9/doc/html/globals_defs.html",
     "ext/parsley/json-c-0.9/doc/html/globals_enum.html",
     "ext/parsley/json-c-0.9/doc/html/globals_eval.html",
     "ext/parsley/json-c-0.9/doc/html/globals_func.html",
     "ext/parsley/json-c-0.9/doc/html/globals_type.html",
     "ext/parsley/json-c-0.9/doc/html/globals_vars.html",
     "ext/parsley/json-c-0.9/doc/html/index.html",
     "ext/parsley/json-c-0.9/doc/html/json_8h.html",
     "ext/parsley/json-c-0.9/doc/html/json__object_8h.html",
     "ext/parsley/json-c-0.9/doc/html/json__object__private_8h.html",
     "ext/parsley/json-c-0.9/doc/html/json__tokener_8h.html",
     "ext/parsley/json-c-0.9/doc/html/json__util_8h.html",
     "ext/parsley/json-c-0.9/doc/html/linkhash_8h.html",
     "ext/parsley/json-c-0.9/doc/html/printbuf_8h.html",
     "ext/parsley/json-c-0.9/doc/html/structarray__list.html",
     "ext/parsley/json-c-0.9/doc/html/structjson__object.html",
     "ext/parsley/json-c-0.9/doc/html/structjson__object__iter.html",
     "ext/parsley/json-c-0.9/doc/html/structjson__tokener.html",
     "ext/parsley/json-c-0.9/doc/html/structjson__tokener__srec.html",
     "ext/parsley/json-c-0.9/doc/html/structlh__entry.html",
     "ext/parsley/json-c-0.9/doc/html/structlh__table.html",
     "ext/parsley/json-c-0.9/doc/html/structprintbuf.html",
     "ext/parsley/json-c-0.9/doc/html/tab_b.gif",
     "ext/parsley/json-c-0.9/doc/html/tab_l.gif",
     "ext/parsley/json-c-0.9/doc/html/tab_r.gif",
     "ext/parsley/json-c-0.9/doc/html/tabs.css",
     "ext/parsley/json-c-0.9/doc/html/unionjson__object_1_1data.html",
     "ext/parsley/json-c-0.9/install-sh",
     "ext/parsley/json-c-0.9/json.h",
     "ext/parsley/json-c-0.9/json.pc",
     "ext/parsley/json-c-0.9/json.pc.in",
     "ext/parsley/json-c-0.9/json_object.c",
     "ext/parsley/json-c-0.9/json_object.h",
     "ext/parsley/json-c-0.9/json_object_private.h",
     "ext/parsley/json-c-0.9/json_tokener.c",
     "ext/parsley/json-c-0.9/json_tokener.h",
     "ext/parsley/json-c-0.9/json_util.c",
     "ext/parsley/json-c-0.9/json_util.h",
     "ext/parsley/json-c-0.9/libjson.la",
     "ext/parsley/json-c-0.9/libtool",
     "ext/parsley/json-c-0.9/linkhash.c",
     "ext/parsley/json-c-0.9/linkhash.h",
     "ext/parsley/json-c-0.9/ltmain.sh",
     "ext/parsley/json-c-0.9/missing",
     "ext/parsley/json-c-0.9/printbuf.c",
     "ext/parsley/json-c-0.9/printbuf.h",
     "ext/parsley/json-c-0.9/stamp-h1",
     "ext/parsley/json-c-0.9/test1",
     "ext/parsley/json-c-0.9/test1.c",
     "ext/parsley/json-c-0.9/test2",
     "ext/parsley/json-c-0.9/test2.c",
     "ext/parsley/json-c-0.9/test3",
     "ext/parsley/json-c-0.9/test3.c",
     "ext/parsley/libtool",
     "ext/parsley/ltmain.sh",
     "ext/parsley/missing",
     "ext/parsley/parsed_xpath.c",
     "ext/parsley/parsed_xpath.h",
     "ext/parsley/parser.y",
     "ext/parsley/parsley.c",
     "ext/parsley/parsley.h",
     "ext/parsley/parsley_main.c",
     "ext/parsley/parsleyc_main.c",
     "ext/parsley/regexp.c",
     "ext/parsley/regexp.h",
     "ext/parsley/scanner.l",
     "ext/parsley/test/ambiguous.html",
     "ext/parsley/test/ambiguous.json",
     "ext/parsley/test/ambiguous.let",
     "ext/parsley/test/array-regression.html",
     "ext/parsley/test/array-regression.json",
     "ext/parsley/test/array-regression.let",
     "ext/parsley/test/backslash.html",
     "ext/parsley/test/backslash.json",
     "ext/parsley/test/backslash.let",
     "ext/parsley/test/bang.html",
     "ext/parsley/test/bang.json",
     "ext/parsley/test/bang.let",
     "ext/parsley/test/collate_regression.html",
     "ext/parsley/test/collate_regression.json",
     "ext/parsley/test/collate_regression.let",
     "ext/parsley/test/contains.html",
     "ext/parsley/test/contains.json",
     "ext/parsley/test/contains.let",
     "ext/parsley/test/content.html",
     "ext/parsley/test/content.json",
     "ext/parsley/test/content.let",
     "ext/parsley/test/cool.html",
     "ext/parsley/test/cool.json",
     "ext/parsley/test/cool.let",
     "ext/parsley/test/craigs-simple.html",
     "ext/parsley/test/craigs-simple.json",
     "ext/parsley/test/craigs-simple.let",
     "ext/parsley/test/craigs.html",
     "ext/parsley/test/craigs.json",
     "ext/parsley/test/craigs.let",
     "ext/parsley/test/crash.html",
     "ext/parsley/test/crash.json",
     "ext/parsley/test/crash.let",
     "ext/parsley/test/css_attr.html",
     "ext/parsley/test/css_attr.json",
     "ext/parsley/test/css_attr.let",
     "ext/parsley/test/default-namespace.json",
     "ext/parsley/test/default-namespace.let",
     "ext/parsley/test/default-namespace.xml",
     "ext/parsley/test/div.html",
     "ext/parsley/test/div.json",
     "ext/parsley/test/div.let",
     "ext/parsley/test/empty.html",
     "ext/parsley/test/empty.json",
     "ext/parsley/test/empty.let",
     "ext/parsley/test/emptyish.html",
     "ext/parsley/test/emptyish.let",
     "ext/parsley/test/fictional-opt.html",
     "ext/parsley/test/fictional-opt.json",
     "ext/parsley/test/fictional-opt.let",
     "ext/parsley/test/fictional.html",
     "ext/parsley/test/fictional.json",
     "ext/parsley/test/fictional.let",
     "ext/parsley/test/function-magic.html",
     "ext/parsley/test/function-magic.json",
     "ext/parsley/test/function-magic.let",
     "ext/parsley/test/hn.html",
     "ext/parsley/test/hn.json",
     "ext/parsley/test/hn.let",
     "ext/parsley/test/malformed-array.html",
     "ext/parsley/test/malformed-array.json",
     "ext/parsley/test/malformed-array.let",
     "ext/parsley/test/malformed-expr.html",
     "ext/parsley/test/malformed-expr.json",
     "ext/parsley/test/malformed-expr.let",
     "ext/parsley/test/malformed-function.html",
     "ext/parsley/test/malformed-function.json",
     "ext/parsley/test/malformed-function.let",
     "ext/parsley/test/malformed-json.html",
     "ext/parsley/test/malformed-json.json",
     "ext/parsley/test/malformed-json.let",
     "ext/parsley/test/malformed-xpath.html",
     "ext/parsley/test/malformed-xpath.json",
     "ext/parsley/test/malformed-xpath.let",
     "ext/parsley/test/match.json",
     "ext/parsley/test/match.let",
     "ext/parsley/test/match.xml",
     "ext/parsley/test/math_ambiguity.html",
     "ext/parsley/test/math_ambiguity.json",
     "ext/parsley/test/math_ambiguity.let",
     "ext/parsley/test/nth-regression.html",
     "ext/parsley/test/nth-regression.json",
     "ext/parsley/test/nth-regression.let",
     "ext/parsley/test/optional.html",
     "ext/parsley/test/optional.json",
     "ext/parsley/test/optional.let",
     "ext/parsley/test/outer-xml.html",
     "ext/parsley/test/outer-xml.json",
     "ext/parsley/test/outer-xml.let",
     "ext/parsley/test/position.html",
     "ext/parsley/test/position.json",
     "ext/parsley/test/position.let",
     "ext/parsley/test/question_regressions.html",
     "ext/parsley/test/question_regressions.json",
     "ext/parsley/test/question_regressions.let",
     "ext/parsley/test/quote.json",
     "ext/parsley/test/quote.let",
     "ext/parsley/test/quote.xml",
     "ext/parsley/test/reddit.html",
     "ext/parsley/test/reddit.json",
     "ext/parsley/test/reddit.let",
     "ext/parsley/test/remote-fail.json",
     "ext/parsley/test/remote.html",
     "ext/parsley/test/remote.json",
     "ext/parsley/test/remote.let",
     "ext/parsley/test/replace.json",
     "ext/parsley/test/replace.let",
     "ext/parsley/test/replace.xml",
     "ext/parsley/test/scope.html",
     "ext/parsley/test/scope.json",
     "ext/parsley/test/scope.let",
     "ext/parsley/test/segfault.html",
     "ext/parsley/test/segfault.json",
     "ext/parsley/test/segfault.let",
     "ext/parsley/test/sg-wrap.html",
     "ext/parsley/test/sg-wrap.json",
     "ext/parsley/test/sg-wrap.let",
     "ext/parsley/test/sg_off.html",
     "ext/parsley/test/sg_off.json",
     "ext/parsley/test/sg_off.let",
     "ext/parsley/test/test.json",
     "ext/parsley/test/test.let",
     "ext/parsley/test/test.xml",
     "ext/parsley/test/trivial.html",
     "ext/parsley/test/trivial.json",
     "ext/parsley/test/trivial.let",
     "ext/parsley/test/trivial2.html",
     "ext/parsley/test/trivial2.json",
     "ext/parsley/test/trivial2.let",
     "ext/parsley/test/unbang.html",
     "ext/parsley/test/unbang.json",
     "ext/parsley/test/unbang.let",
     "ext/parsley/test/unicode.html",
     "ext/parsley/test/unicode.json",
     "ext/parsley/test/unicode.let",
     "ext/parsley/test/whitespace.html",
     "ext/parsley/test/whitespace.json",
     "ext/parsley/test/whitespace.let",
     "ext/parsley/test/whitespace_regression.html",
     "ext/parsley/test/whitespace_regression.json",
     "ext/parsley/test/whitespace_regression.let",
     "ext/parsley/test/yelp-benchmark.rb",
     "ext/parsley/test/yelp-home.html",
     "ext/parsley/test/yelp-home.json",
     "ext/parsley/test/yelp-home.let",
     "ext/parsley/test/yelp.html",
     "ext/parsley/test/yelp.json",
     "ext/parsley/test/yelp.let",
     "ext/parsley/test/youtube.html",
     "ext/parsley/test/youtube.let",
     "ext/parsley/util.c",
     "ext/parsley/util.h",
     "ext/parsley/xml2json.c",
     "ext/parsley/xml2json.h",
     "ext/parsley/y.tab.h",
     "ext/parsley/ylwrap",
     "lib/parsley.rb",
     "parsley-ruby.gemspec",
     "test/test_parsley.rb",
     "test/yelp-benchmark.rb",
     "test/yelp-home.html",
     "test/yelp-home.let",
     "test/yelp.html"
  ]
  s.homepage = %q{http://github.com/fizx/parsley-ruby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib", "ext"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby binding for parsley}
  s.test_files = [
    "test/test_parsley.rb",
     "test/yelp-benchmark.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["> 0.0.0"])
    else
      s.add_dependency(%q<json>, ["> 0.0.0"])
    end
  else
    s.add_dependency(%q<json>, ["> 0.0.0"])
  end
end

