require File.expand_path(File.dirname(__FILE__) + "/../ext/cparsley")
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
      parsley = recursive_stringify(parsley).to_json 
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
  # :sgwrap => [false, true]
  # :collate => [true, false]
  # :base => "http://some/base/href"
  # :allow_net => [true, false]
  # :allow_local => [true, false]
  def parse(options = {})
    options[:file] || options[:string] || (raise ParsleyError.new("must specify what to parse"))
    
    options[:sgwrap] = !!options[:sgwrap]
    options[:is_file] = !!options[:file]
    options[:has_base] = !!options[:base]
    
    options[:base] = options[:base].to_s
    options[:file] = options[:file].to_s
    options[:string] = options[:string].to_s
    
    options[:input]  ||= :html
    options[:output] ||= :ruby
    
    options[:collate] = true unless options.has_key?(:collate)
    options[:prune] = true unless options.has_key?(:prune)
    options[:allow_net] = true unless options.has_key?(:allow_net)
    options[:allow_local] = true unless options.has_key?(:allow_local)
    
    options[:collate] = !!options[:collate]
    options[:prune] = !!options[:prune]
    options[:allow_net] = !!options[:allow_net]
    options[:allow_local] = !!options[:allow_local]
    
    @parsley.parse(options)
  end
  private
  
  def recursive_stringify(obj)
    case obj
    when Hash
      obj.inject({}) do |memo, (k, v)|
        memo[k.to_s] = recursive_stringify(v)
        memo
      end
    when Array
      obj.map{|e| recursive_stringify(e) }
    else
      obj.to_s
    end
  end
  
end
