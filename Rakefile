require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "get_shorty"
    gem.summary = %Q{Shorten resource urls}
    gem.description = %Q{Shorten the url of a resource - at present supports active record models and caches the short url to a database column.}
    gem.email = "louisgillies@yahoo.co.uk"
    gem.homepage = "http://github.com/playgood/get_shorty"
    gem.authors = ["Louis Gillies"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "rest-client", ">= 1.4.2"
    gem.add_dependency "nokogiri", ">= 1.4.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "get_shorty #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
