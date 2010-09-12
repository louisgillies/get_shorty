# Simple wrapper so we can store the api authentication details in the config/bitly.yml file.
require 'rest_client'

module Bitly
  class Client

    attr_accessor :format, :login, :api_key, :response
    BASE_URI = "http://api.bit.ly/v3"


    def initialize(login, api_key, options={})
      @login = login 
      @api_key = api_key
      @format = options[:format] || :json
    end

    def default_params
      {:login => login, :apiKey => api_key, :format => format}
    end

    def get(end_point, options={})
      RestClient.get(BASE_URI + end_point, :params => default_params.merge(options))
    end
    
    def shorten(url)
      response = get("/shorten", :longUrl => url)
      @response = ShortenResponse.new(response)
      @response.url
    rescue
       nil
    end

    # creates a connection with default loaded.
    def self.connection(options={})
      @connection ||= Bitly::Client.new(Bitly::Config.login, Bitly::Config.api_key, options)
    end
  end

  
end




