require File.dirname(__FILE__) + '/../spec_helper'

describe EasyTranslate do

  it 'should have LANGUAGES' do
    EasyTranslate::LANGUAGES.should be_a(Hash)
    EasyTranslate::LANGUAGES['en'].should == 'english'
  end

  it 'should have a version' do
    EasyTranslate::VERSION.split('.').length.should == 3
  end

end
