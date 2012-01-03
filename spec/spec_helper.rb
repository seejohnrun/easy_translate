# Start SimpleCov
begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  puts 'for coverage please install SimpleCov'
end

# Require the actual project
require 'ostruct'
require File.dirname(__FILE__) + '/../lib/easy_translate'
