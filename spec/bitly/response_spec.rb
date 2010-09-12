require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Bitly::Response do

  let(:json_response) { { :data => {:url => "test.com", :hash => "blah" } }.to_json }
  let(:xml_response) { "<data><url>test.com</url><hash>blah</hash></data>"}
  context "an instance" do
    it "should error without a response" do
      lambda {
        Bitly::Response.new
      }.should raise_error(ArgumentError)
    end
    
    let(:response) { Bitly::Response.new( json_response ) }
    
    it "should deafult the format to :json" do
      response.respond_to?(:format).should be_true
      response.format.should == :json
    end
    
    it "should set the correct parser" do
      response.respond_to?(:parser).should be_true
      response.parser.should == JSON
    end
    
    context "formatted as xml" do
      let(:xml) { Bitly::Response.new( xml_response, :xml) }
      
      it "should format as xml" do
        xml.format.should == :xml
      end
      
      it "should set the xml parser" do
        xml.respond_to?(:parser).should be_true
        xml.parser.should == Nokogiri::XML
      end
    end
    
    context "an unsupported format" do
      it "should raise an error" do
        lambda { Bitly::Response.new( json_response, :pink ) }.should raise_error(Bitly::UnsupportedFormat)
      end
    end
        
  end

  describe Bitly::ShortenResponse do
    let(:shorten_response) { Bitly::ShortenResponse.new( json_response ) }
    
    {:url => "test.com", :hash => "blah" }.each do |method, value| 
      it "should set the #{method}" do
        shorten_response.respond_to?(method).should be_true
        shorten_response.send(method).should == value
      end
    end
  end
  
end
