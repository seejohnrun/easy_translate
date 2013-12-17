# Start SimpleCov
begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  puts 'for coverage please install SimpleCov'
end

# Require the actual project
$: << File.expand_path('../lib', __FILE__)
require 'easy_translate'
