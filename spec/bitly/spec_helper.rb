def set_bitly_configuration
  Bitly::Config.set do |config|
    config.login = "tester"
    config.api_key = "test_key"
  end
end