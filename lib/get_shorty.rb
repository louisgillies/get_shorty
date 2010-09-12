require File.join(File.dirname(__FILE__), "providers/init")

module GetShorty
  def self.included(base) #:nodoc:
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    # Returns the short_url_options defined by each call to
    # has_short_url.
    def short_url_options
      @short_url_options
    end
    
    def shortening_serivce
      @shortening_serivce
    end
    
    def has_short_url(options={})
      include InstanceMethods
      include ActionController::UrlWriter if defined?(ActionController )# non mvc - but need to know the url for model instance to persist the short_url.
      @short_url_options = {:long_url_method => :generate_long_url, :short_url_method => :short_url}.update(options) 
      @shortening_serivce = options[:shortener_service] || Bitly::Client.connection
      @long_url_host = options[:long_url_host]
    end
    
    # for Rails when using UrlWriter
    def get_long_url_host
      @long_url_host
    end
  end

  module InstanceMethods
    
    def has_short_url?
      self.send("#{self.class.short_url_options[:short_url_method]}?")
    end
    
    def get_short_url!(long_url=nil)
      short_url = get_short_url(long_url)
      self.update_attributes( self.class.short_url_options[:short_url_method] => short_url ) unless has_short_url? || self.readonly?
      short_url
    end
    
    def set_short_url(short_url=generate_short_url)
      if short_url
        self.update_attributes( self.class.short_url_options[:short_url_method] => short_url )
      end
    end
  
    def get_short_url(url=nil)
      self.send(self.class.short_url_options[:short_url_method]) || generate_short_url(url)
    end
    
    # Goes against the MVC conventions (although we are generating this for the purpose of creating a short_url for the database so it is to do with the Model.)
    def generate_long_url()
      begin
        send("#{self.class.name.downcase}_url", self, :host => self.class.get_long_url_host) unless self.new_record? # Can't generate the url until we have an id and title.
      end
    end
    
    def generate_short_url(long_url=nil)
      url = long_url || self.send(self.class.short_url_options[:long_url_method])
      if url
        self.class.shortening_serivce.shorten( url ) 
      end
    end
  end
end

