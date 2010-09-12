$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'get_shorty'
require 'spec'
require 'spec/autorun'
require 'rubygems'
require 'active_record'
require "rest_client"
require 'bitly/spec_helper'
require 'active_record_helper'

Spec::Runner.configure do |config|
  
end
