require File.dirname(__FILE__) + '/spec_helper'
require 'yaml.rb'

describe 'translate' do

  it 'should be able to convert a yaml file' do
    locale = LocaleBase.new YAML.load_file('spec/examples/sample/locale_basic.yml')
    locale.convert :to => :spanish
  end

end
