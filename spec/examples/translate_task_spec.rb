require File.dirname(__FILE__) + '/spec_helper'

require 'pp'

describe 'translate' do

  it 'should be able to convert a basic array' do
    locale = LocaleBase.new ['one', 'two', 'three']
    locale.convert(:to => :spanish).should == ['uno', 'dos', 'tres']
  end
  
  it 'should be able to convert a yaml file' do
    locale = LocaleBase.new YAML.load_file('spec/examples/sample/locale_basic.yml')
    lambda do
      locale.convert(:to => :spanish)
    end.should_not raise_error
  end

  it 'should be able to convert a hash with an array inside of it, and skip the keys' do
    locale = LocaleBase.new 'numbers' => ['one', 'two', 'three']
    locale.convert(:to => :es).should == { 'numbers' => ['uno', 'dos', 'tres'] }
  end

  it 'should be able to convert a single string' do
    locale = LocaleBase.new 'uno'
    locale.convert(:from => :es, :to => :en).should == 'one'
  end

  it 'should be able to have a complicated hash set' do
    locale = LocaleBase.new 'numbers' => { 'singles' => ['one', 'two'], 'teens' => ['ten', 'fifteen'] }
    locale.convert(:from => :en, :to => :es).should == { 'numbers' => { 'singles' => ['uno', 'dos'], 'teens' => ['diez', 'quince'] } }
  end

  it 'should be able to work with {{variables}} without modifying them' do
    locale = LocaleBase.new 'one {{variable}} two'
    locale.convert(:from => :en, :to => :es).should == 'uno {{variable}} dos'
  end

  it 'should be able to deal with multiple variables without confusing them' do
    locale = LocaleBase.new 'one {{var1}} two {{var2}} three'
    locale.convert(:from => :en, :to => :es).should == 'uno {{var1}} dos {{var2}} tres'
  end

  it 'should be able to deal with multiple variables with non-alphanum chars' do
    locale = LocaleBase.new 'one {{:var_1}} two {{:var_2}} three'
    locale.convert(:from => :en, :to => :es).should == 'uno {{:var_1}} dos {{:var_2}} tres'
  end

  it 'should be able to have two of the same variable in a string' do
    locale = LocaleBase.new 'one {{variable}} one {{variable}} two'
    locale.convert(:from => :en, :to => :es).should == 'uno {{variable}} uno {{variable}} dos'
  end

  it 'should be able to have two variables separated by a space' do
    locale = LocaleBase.new 'one {{variable1}} {{variable2}} two'
    locale.convert(:from => :en, :to => :es).should == 'uno {{variable1}} {{variable2}} dos'
  end

  it 'should be able to have two variables right next to each other' do
    locale = LocaleBase.new 'one {{variable1}}{{variable2}} two'
    locale.convert(:from => :en, :to => :es).should == 'uno {{variable1}}{{variable2}} dos'
  end

  it 'should be able to operate on extremely large objects, by chunking' do
    obj = []
    1000.times { obj << "Now is the time for all good men to come to the aid of their country" }
    locale = LocaleBase.new obj
    translation = locale.convert(:from => :en, :to => :en)
    translation.size.should == 1000
    translation.each { |t| t.should == 'Now is the time for all good men to come to the aid of their country' }
  end
  
end
