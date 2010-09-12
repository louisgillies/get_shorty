require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GetShorty do
  before(:each) do
    Bitly::Config.set do |config|
      config.login = "tester"
      config.api_key = "test_key"
    end
    @post = Post.new(:url => "http://testserver.com")
  end
  
  context "when included" do
    it "should add the has_short_url class method" do
      Post.respond_to?(:has_short_url).should be_true
    end
    
    it "should add the the shortener_service method" do
      Post.respond_to?(:shortening_serivce).should be_true
    end
    
    it "should set the default shortener service to bitly" do
      Post.shortening_serivce.should == Bitly::Client.connection
    end
    
    it "should set the default options" do
      Post.short_url_options[:short_url_method].should == :short_url
      Post.short_url_options[:long_url_method].should == :generate_long_url
      
    end
  end
  
  context "an instance" do
    [:set_short_url, :get_short_url, :generate_short_url, :generate_long_url, :has_short_url?].each do |method|
      it "should respond to #{method}" do
        @post.respond_to?(method).should be_true
      end
    end

    before(:each) do
      # stub web call
      Bitly::Client.connection.stub!(:shorten => "v.co")
    end
    
    it "should not have a short_url" do
      @post.has_short_url?.should be_false
    end
   
    it "should not call the service when the record is not saved" do
      Bitly::Client.connection.should_not_receive(:shorten)
      @post.get_short_url
    end
    
    it "should not update the record until the record is saved" do
      @post.should_not_receive(:update_attributes)
      @post.set_short_url
    end
     
    it "should update the record when the short url is set" do
      @post.save
      @post.stub!(:post_url => "http://www.example.com/post/1")
      @post.should_receive(:update_attributes).with( {Post.short_url_options[:short_url_method] => "v.co"} )
      @post.set_short_url
    end

  end
end
