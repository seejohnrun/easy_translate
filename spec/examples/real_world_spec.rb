# encoding: utf-8
require 'spec_helper'

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
      expect(res).to eq('hola mundo')
    end

    it 'should be able to translate multiple' do
      res = EasyTranslate.translate ['hello world', 'i love you'], :to => :spanish
      expect(res).to eq(['hola mundo', 'te amo'])
    end

    it 'should work concurrently' do
      res = EasyTranslate.translate ['hello world', 'i love you', 'good morning'], :to => :spanish, :concurrency => 2, :batch_size => 1
      expect(res).to eq(['hola mundo', 'te amo', '¡buenos días'])
    end
  end

  describe :detect do

    it 'should be able to detect one' do
      res = EasyTranslate.detect 'hello world'
      expect(res).to eq('en')
    end

    it 'should be able to translate one' do
      res = EasyTranslate.detect ['hello world', 'hola mundo']
      expect(res).to eq(['en', 'es'])
    end

  end

  describe :translations_available_from do

    it 'should be able to get a list of all' do
      res = EasyTranslate.translations_available
      expect(res).to be_a Array
    end

    it 'should be able to get a list of all from es' do
      res = EasyTranslate.translations_available('yi')
      expect(res).to be_a Array
    end

  end

end
