require 'nokogiri'

module Bitly
  class Response
    attr_reader :format
    
    def parse; end
    
    def initialize(response, format=:json)
      @response = response
      @format = format
      @parser = parser
      parse
    end
    
    
    def parser
      case format 
        when :json
          return JSON
        when :xml
          return Nokogiri::XML
        else
          raise UnsupportedFormat, format
      end
    end
  end
  
  class ShortenResponse < Response
    attr_reader :url, :long_url, :hash, :global_hash
    
    # Assuming format is always json for now.
    def parse
      @parsed_response = @parser.parse(@response)
      @url = @parsed_response["data"]["url"]
      @hash = @parsed_response["data"]["hash"]
    end

  end
  
  class UnsupportedFormat < StandardError
  end
  
end
