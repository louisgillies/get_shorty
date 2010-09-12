$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :posts do |t|
    t.string :title, :url, :short_url
    t.text :excerpt, :body
  end
end

set_bitly_configuration

class Post < ActiveRecord::Base
  # to replicate rails url_writer
  def self.default_url_options
    {}
  end
  
  include GetShorty
  has_short_url
  

end