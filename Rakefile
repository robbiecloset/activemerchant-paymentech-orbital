require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "activemerchant-paymentech-orbital"
    gem.summary = "A gem to provide a ruby interface for Chase Paymentech Orbital payment gateway."
    gem.description = "A gem to provide a ruby interface for Chase Paymentech Orbital payment gateway. It has been development thus far to meet specific ends, so not all functionality is present."
    gem.email = "john@mintdigital.com"
    gem.homepage = "http://github.com/johnideal/activemerchant-paymentech-orbital"
    gem.authors = ["John Corrigan"]
    gem.add_dependency("activemerchant", "= 1.4.2")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/units/**/*_test.rb'
  test.verbose = true
end

Rake::TestTask.new(:remote) do |test|
  test.libs << 'test'
  test.pattern = 'test/remote/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "activemerchant-paymentech-orbital #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
