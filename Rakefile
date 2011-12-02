# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bio-affy"
  gem.homepage = "http://github.com/pjotrp/bioruby-affy"
  gem.license = "MIT"
  gem.summary = %Q{Parse Affymetrix CEL/CDF files}
  gem.description = %Q{Affymetrix microarray file format parser
  (CEL/CDF) for Ruby. FFI binding to Biolib port of R/Affyio by Benjamin Milo Bolstad}
  gem.email = "pjotr.public01@thebird.nl"
  gem.authors = ["Pjotr Prins"]
  gem.extensions = "ext/src/mkrf_conf.rb"
  gem.files += Dir['lib/**/*'] + Dir['ext/**/*']
  gem.rubyforge_project = "nowarning"

  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

file "lib/libbio-affy.so" => Dir.glob("ext/src/*{.rb,.c}") do
   Dir.chdir("ext/src") do
     ruby "mkrf_conf.rb"
     sh "rake"
  end
  cp "ext/src/libbio-affy.so", "lib/libbio-affy.so"
end

desc "Default builds and tests bio-affy"
task :default => [:build, :test]

desc "Build extension"
task :build => [ "lib/libbio-affy.so" ] do 
end

task :test => :spec

# require 'rdoc/task'
# Rake::RDocTask.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""

#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "bio-affy #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
