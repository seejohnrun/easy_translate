require 'rspec/core/rake_task'
require 'bundler'

task :build => :test do
  system "gem build easy_translate.gemspec"
end

task :release => :build do
  # tag and push
  version = Bundler.load_gemspec('easy_translate.gemspec').version
  system "git tag v#{version}"
  system "git push origin --tags"
  # push the gem
  system "gem push easy_translate-#{version}.gem"
end
 
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  fail_on_error = true # be explicit
end

task :default => :test
