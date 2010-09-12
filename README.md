# get_shorty

A plugin for rails that shortens a url using the bitly shortening service and persists to the model.

* Default shortening provider is bitly
* Easily extendible by adding client / provider for other shortening service eg t.co from twitter when a public api is available.

## Installation

### As a rails plugin
    script/plugin install git://github.com/playgood/get_shorty.git
  
Then in the model that you want to add a short url to - this model must have a `short_url` column (this is the default but can be customised see options below)

    Class ModelName
      include GetShorty
      has_short_url  
    end
    
has_short_url by default relies on the [Bitly](http://bit.ly/ "Bitly") API to shorten urls   
You need to register with Bitly to get a login and api_key. 
This needs to be set in a rails initializer to allow the Bitly provider to connect to your api account.

In your initializer
    
    Bitly::Config.set do |config|
      config.login = "my_bitly_login"
      config.api_key = "BLAH_BLAH_BLAH"
    end
    
or with a yaml file with the api_key and login keys. 

    api_key: "BLAH_BLAH_BLAH"
  
    login: "my_bitly_login"

    
    Bitly::Config.set do |config|
      config.config_file = File.join(Rails.root, "path/to/config/file")
    end
    
Or

You can roll out your own shortening provider - all it has to do is respond to the shorten method.
This can then be set using has_short_url option :shortening_service

For example:
    Class ModelName
      include GetShorty
    
      has_short_url :shortening_service => MyShortener
    end
  
_This assumes you have defined a Class `MyShortener` which respond to the method `shorten` with the parameter url_

## Parameters &amp; Options

`has_short_url` has the following options:
* `long_url_host` - this is required so the rails url_helper method work. Takes a string or a hash with a value for each environment. 
* `:shortening_service` - default is Bitly::Client.connection - you can create your own (it just needs to be an object that responds to `.shorten(url)`)
* `:short_url_method`  - default is :short_url (most commonly a db column - but not necessarily)
* `:long_url_method`   - default is :generate_long_url - In a rails app this would probably be a resourceful route helper method for example page_url.


## Integration

  To try to keep the design of this plugin / gem clean and allow for future integration into more ruby frameworks there are no automatic hooks or callbacks to trigger the 
  shortening service.
  
  You will have to add these yourself.
  
  For example in rails
  
    Class ModelName
      include GetShorty
      has_short_url
      
      after_create :set_short_url
    end
    
  This allows you more flexibility than adding callbacks into the plugin. For example you may want to process the api calls to bitly out of process using delayed_job or something similar.
  
     
## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## TODO

* support for other ORM - at present only works with ActiveRecord
* support for other shortening url services.

## Copyright

Copyright (c) 2010 Louis Gillies. See LICENSE for details.
