module Bitly
  module Config
    
    class << self
      attr_accessor :login, :api_key, :config_file
      
      def set(&block)
        self.class_eval(&block) if block_given?
        load_config
      end
      
      def load_config()
         unless config_file.nil?
           api_details = YAML.load(File.open(config_file)).symbolize_keys 
           @api_key, @login = api_details[:api_key], api_details[:username]
         end
      end

      def login
        return @login unless @login.nil?
        self.load_config
        raise "Bitly Login must be defined" if @login.nil?
        @login
      end

      def api_key
        return @api_key unless @api_key.nil?
        self.load_config
        raise "Bitly Api key must be defined" if @api_key.nil?
        @api_key
      end
    end
  end
end