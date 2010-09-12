require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Bitly::Config do
  it "should load the config/bitly.yml file and read the keys" do
    Bitly::Config.respond_to?(:load_config).should be_true
    Bitly::Config.respond_to?(:api_key).should be_true
    Bitly::Config.respond_to?(:login).should be_true
  end
end
