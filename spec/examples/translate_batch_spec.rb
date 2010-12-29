# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe 'translate_batch' do

  it 'should be able to translate a single thing as batch' do
    translations = EasyTranslate.translate(['hello'], :from => :english, :to => :spanish)
    translations.should == ['hola']
  end

  it 'should be able to take multiple texts at the same time and translate them' do
    translations = EasyTranslate.translate(['Hello', "Goodbye"], :from => :en, :to => :es)
    translations.should == ['Hola', 'Adiós']
  end
  
  it 'should be able to take multiple languages to translate to, and do so' do
    translations = EasyTranslate.translate('hello', :from => :en, :to => [:french, :german, :spanish, :italian])
    translations.should == ['bonjour', 'hallo', 'hola', 'ciao']
  end
  
  it 'should be able to take multiple languages, and multiple strings ... and handle that ugliness' do
    translations = EasyTranslate.translate(['hello', 'goodbye'], :from => :en, :to => [:spanish, :italian])
    translations.should == [['hola', 'adiós'], ['ciao', 'addio']]
  end

  it 'should be consistent in return format' do
    translations = EasyTranslate.translate(['hello', 'goodbye'], :from => :en, :to => [:spanish])
    translations.should == [['hola', 'adiós']]
  end

  it 'should be consistent in return format' do
    translations = EasyTranslate.translate(['hello'], :from => :en, :to => [:spanish, :italian])
    translations.should == [['hola'], ['ciao']]
  end

  it 'should be able to translate into every language in the world' do
    languages = EasyTranslate::LANGUAGES.keys   
    translations = EasyTranslate.translate('hello', :from => :en, :to => languages)
    translations.size.should == languages.size
  end
  
end
