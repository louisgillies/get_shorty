require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Bitly::Client do
  before do
    set_bitly_configuration
  end
  
  [:new, :connection].each do |method| 
    it "should respond to #{method}" do
      Bitly::Client.respond_to?(method).should be_true
    end
  end
  
  it "should return a authenticated instance with connection" do
    Bitly::Client.connection.class.should == Bitly::Client
  end
  
  context "an instance" do
    
    let(:client) { Bitly::Client.new("login_test", "api_key_test")}
    
    it "should set the api_key" do
      client.respond_to?(:api_key).should be_true
      client.api_key.should == "api_key_test"
    end
    
    it "should set the login" do
      client.respond_to?(:login).should be_true
      client.login.should == "login_test"
    end
    
    it "should set the format to json by default" do
      client.respond_to?(:format).should be_true
      client.format.should == :json
    end
    
    it "should have a shorten method" do
      client.respond_to?(:shorten).should be_true
    end
    
    it "should set the default params" do
      client.respond_to?(:default_params).should be_true
      client.default_params.should == {:login => "login_test", :apiKey => "api_key_test", :format => :json}
    end
    
    context "with custom options" do
      it "should set the format to xml" do
        new_client = Bitly::Client.new("login", "key", :format => :xml)
        new_client.format.should == :xml
      end
    end
    
    describe "shortening a url" do
      before do
        RestClient.should_receive(:get).and_return({ :data => {:url => "test.com", :hash => "blah" } }.to_json)
        @url = client.shorten("test_url")
      end
      
      it "should return the url" do
        @url.should == "test.com"
      end
      
      it "should keep the response in memory" do
        client.response.should_not be_nil
        client.response.url.should == @url
        client.response.hash.should == "blah"
      end
    end
  end
end
