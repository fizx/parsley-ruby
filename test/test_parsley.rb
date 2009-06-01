require "test/unit"
require File.dirname(__FILE__) + "/../lib/parsley"

class TestParsley < Test::Unit::TestCase
  def setup
    @page = File.expand_path(File.dirname(__FILE__) + "/yelp.html")
    @home = File.expand_path(File.dirname(__FILE__) + "/yelp-home.html")
    @let  = File.expand_path(File.dirname(__FILE__) + "/yelp-home.let")
  end
  
  def test_yelp
    @parsley = Parsley.new(File.read(@let))
    out = @parsley.parse(:file => @home)
    assert_equal "/c/sf/shopping", out["categories"][0]["href"]
  end
  
  def test_yelp_xml
    @parsley = Parsley.new(File.read(@let))
    out = @parsley.parse(:file => @home, :output => :xml)
  end
  
  def test_broken
    @parsley = Parsley.new("hi" => "no-ns:match(h1)")
    assert_raises(ParsleyError) {
      @parsley.parse(:file => @page)
    }
  end
  
  def test_simple
    @parsley = Parsley.new("hi" => "h1")
    assert_equal({"hi" => "Nick's Crispy Tacos"}, @parsley.parse(:file => @page))
  end
  
  def test_simple_string
    @parsley = Parsley.new("hi" => "h1")
    assert_equal({"hi" => "Nick's Crispy Tacos"}, @parsley.parse(:string => "<html><body><h1>Nick's Crispy Tacos</h1></body></html>"))
  end  
  
  def test_xml
    @parsley = Parsley.new("hi" => "h1")
    xml = "<?xml version=\"1.0\"?>\n<parsley:root xmlns:parsley=\"http://parselets.com/json\"><hi position=\"63\">Nick's Crispy Tacos</hi></parsley:root>\n"
    assert_equal(xml, @parsley.parse(:file => @page, :output => :xml))
  end

  def test_sgwrap
    @parsley = Parsley.new("hi" => "p sg_wrap")
    html = "<p><b>hi</b>world</p>"
    assert_equal({"hi" => "world"}, @parsley.parse(:string => html, :sgwrap => true))
  end
  
  def test_sgwrap_off
    @parsley = Parsley.new("hi" => "p sg_wrap")
    html = "<p><b>hi</b>world</p>"
    assert_raises(ParsleyError) do
      @parsley.parse(:string => html, :sgwrap => false)
    end
  end

  
  def test_json
    @parsley = Parsley.new("hi" => "h1")
    assert_equal('{ "hi": "Nick\'s Crispy Tacos" }', @parsley.parse(:file => @page, :output => :json))
  end
  
  def test_rescuable_file_error
    @parsley = Parsley.new("hi" => "h1")
    @nonexistant_file = File.dirname(__FILE__) + "/../fixtures/yelp.html"
    assert_equal({"hi" => "Nick's Crispy Tacos"}, @parsley.parse(:file => @nonexistant_file)) rescue nil
  end
  
  def test_array_string
    @parsley = Parsley.new({"foo" => ["li"]})
    out = @parsley.parse(:file => @page)
    assert_kind_of Hash, out
    assert_kind_of Array, out["foo"], out.inspect
    assert out["foo"].length > 1
  end
end