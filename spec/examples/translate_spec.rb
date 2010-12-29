# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe 'translate' do

  before(:each) do
    EasyTranslate.api_key = nil
  end
  
  it 'should remain the same after calling translate' do
    EasyTranslate.api_key = nil
    text = 'hello'
    EasyTranslate.translate(text, :to => 'es')
    text.should == 'hello'
  end
  
  it 'should be able to translate a very basic string between two valid romance languages' do
    text = 'Hello, world'
    translation = EasyTranslate.translate(text, :from => 'en', :to => 'es')
    translation.should == 'Hola, mundo'
  end
  
  it 'should be able to translate a very basic string between romance and non-romance languages' do
    text = 'Hello, world'
    translation = EasyTranslate.translate(text, :from => 'en', :to => 'ja')
    translation.should == 'こんにちは、世界'
  end
  
  it 'should be able to translate a very basic string given no source language' do
    text = 'Hello, world'
    translation = EasyTranslate.translate(text, :to => 'es')
    translation.should == 'Hola, mundo'
  end
  
  it 'should be able to take a variety of language types all the same' do
    text = 'Hello, world'
    translation = EasyTranslate.translate(text, :to => 'es')
    translation.should_not == nil # just make sure
    # try other types
    EasyTranslate.translate(text, :to => 'spanish').should == translation
    EasyTranslate.translate(text, :to => :es).should == translation
    EasyTranslate.translate(text, :to => :spanish).should == translation
  end
  
  it 'should raise an exception when trying to translate to something that does not exist' do
    text = 'Hello, world'
    lambda do
      EasyTranslate.translate(text, :to => 'fake')
    end.should raise_error(ArgumentError, 'please supply a valid language')
  end
  
  it 'should raise an error given no string' do
    lambda do
      EasyTranslate.translate('', :to => 'english')
    end.should raise_error(ArgumentError, 'no string given')
  end
  
  it 'should make round trips with html' do
    translation = EasyTranslate.translate('<b>hello</b>', :to => 'spanish', :html => true)
    translation.should == "<b>hola</b>"
  end

  it 'should be able to provide an API key' do
    lambda do
      EasyTranslate.api_key = 'key'
      EasyTranslate.translate('hello', :to => 'spanish')
    end.should raise_error(EasyTranslateException, 'invalid key')
  end
  
  it 'should be able to provide an override API key' do
    lambda do
      EasyTranslate.translate('hello', :to => 'spanish', :key => 'override')
    end.should raise_error(EasyTranslateException, 'invalid key')
  end
  
  it 'should be able to hold onto a non-forced API key for multiple calls' do
    EasyTranslate.api_key = 'key'
    lambda do
      EasyTranslate.translate('hello', :to => 'spanish')
    end.should raise_error(EasyTranslateException, 'invalid key')
    # and again
    lambda do
      EasyTranslate.translate('hello', :to => 'spanish')
    end.should raise_error(EasyTranslateException, 'invalid key')
  end

  it 'should be able to translate something really long, since it uses POST, and not GET' do
    mystring = ''
    f = File.open('spec/examples/sample/gettysburg.txt', 'r')
    f.each_line { |line| mystring << line }
    # try to translate
    lambda do
      EasyTranslate.translate(mystring, :to => :spanish)
    end.should_not raise_error
  end

  it 'should be able to work with quotes' do
    translation = EasyTranslate.translate("'hello'", :to => :english)
    translation.should == "'hello'"
  end

  it 'should be able to work with double quotes' do
    translation = EasyTranslate.translate('"hello"', :to => :english)
    translation.should == '"hello"'
  end

  it 'should be able to handle to translate calls in succession without issue' do
    lambda do
      EasyTranslate.translate('hello', :to => :spanish)
      EasyTranslate.translate('hello', :to => :spanish)
    end.should_not raise_error
  end
    
end
