require File.dirname(__FILE__) + '/../spec_helper'

describe EasyTranslate do

  before :each do
    if ENV['API_KEY']
      EasyTranslate.api_key = ENV['API_KEY']
    else
      pending 'please provide an API_KEY for this suite'
    end
  end

  describe :translate do

    it 'should be able to translate one' do
      res = EasyTranslate.translate 'hello world', :to => :spanish
      res.should == 'hola mundo'
    end

    it 'should be able to translate multiple' do
      res = EasyTranslate.translate ['hello world', 'i love you'], :to => :spanish
      res.should == ['hola mundo', 'te quiero']
    end

  end

  describe :detect do

    it 'should be able to detect one' do
      res = EasyTranslate.detect 'hello world'
      res.should == 'en'
    end

    it 'should be able to translate one' do
      res = EasyTranslate.detect ['hello world', 'hola mundo']
      res.should == ['en', 'es']
    end

  end

  describe :translations_available_from do

    it 'should be able to get a list of all' do
      res = EasyTranslate.translations_available
      res.should be_a Array
    end

    it 'should be able to get a list of all from es' do
      res = EasyTranslate.translations_available('yi')
      res.should be_a Array
    end

  end

end
