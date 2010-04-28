require File.dirname(__FILE__) + '/spec_helper'

describe 'detect' do
  
  it 'should be able to detect a basic language string' do
    EasyTranslate.detect('Now is the time for all good men to come to the aid of their country').should == 'en'
  end
  
  it 'should raise an error given no string' do
    lambda do
      EasyTranslate.detect('')
    end.should raise_error(ArgumentError, 'no string given')
  end
  
end