require 'rspec/core/rake_task'
require File.dirname(__FILE__) + '/lib/easy_translate/version'
 
task :build => :test do
  system "gem build easy_translate.gemspec"
end

task :release => :build do
  # tag and push
  system "git tag v#{EasyTranslate::VERSION}"
  system "git push origin --tags"
  # push the gem
  system "gem push easy_translate-#{EasyTranslate::VERSION}.gem"
end
 
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  fail_on_error = true # be explicit
end
