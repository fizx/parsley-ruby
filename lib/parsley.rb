require File.dirname(__FILE__) + "/../ext/cparsley"
require "rubygems"
require "json"
require "thread"

class Parsley
  
  def self.user_agent=(agent)
    @user_agent = agent
    CParsley.set_user_agent(agent.to_s)
  end
  
  def self.user_agent
    @user_agent
  end
  
  def initialize(parsley, incl = "")
    if(parsley.is_a?(Hash))
      parsley = parsley.to_json 
    end
    @@mutex ||= Mutex.new
    @@mutex.synchronize do
      @parsley = CParsley.new(parsley, incl)
    end
  end
  
  # Valid options:
  #
  # Requires one of:
  # :file -- the input file path or url
  # :string -- the input string
  #
  # And optionally (default is the first listed value):
  # :input => [:html, :xml]
  # :output => [:ruby, :json, :xml]
  # :prune => [true, false]
  # :base => "http://some/base/href"
  # :allow_net => [true, false]
  # :allow_local => [false, true]
  def parse(options = {})
    options[:file] || options[:string] || (raise ParsleyError.new("must specify what to parse"))
    
    options[:is_file] = !!options[:file]
    options[:has_base] = !!options[:base]
    
    options[:base] = options[:base].to_s
    options[:file] = options[:file].to_s
    options[:string] = options[:string].to_s
    
    options[:input]  ||= :html
    options[:output] ||= :ruby
    
    options[:prune] = true unless options.has_key?(:prune)
    options[:allow_net] = true unless options.has_key?(:allow_net)
    
    options[:prune] = !!options[:prune]
    options[:allow_net] = !!options[:allow_net]
    options[:allow_local] = !!options[:allow_local]
    
    @parsley.parse(options)
  end
end