require 'spec_helper'

klass = EasyTranslate::TranslationTarget::TranslationTargetRequest
describe klass do

  describe :params do

    it 'should include target in params if given' do
      req = klass.new('en')
      req.params[:target].should == 'en'
    end

    it 'should not include target by default' do
      req = klass.new
      req.params[:target].should be_nil
    end

    it 'should use default key' do
      EasyTranslate.api_key = 'abc'
      request = klass.new('en')
      request.params[:key].should == 'abc'
    end

    it 'should allow overriding of params' do
      EasyTranslate.api_key = 'abc'
      request = klass.new('en', :key => 'def')
      request.params[:key].should == 'def'
    end

    it 'should allow overriding of key as api_key' do
      EasyTranslate.api_key = 'abc'
      request = klass.new('abc', :api_key => 'def', :to => 'es')
      request.params[:key].should == 'def'
      request.params[:api_key].should be_nil
    end

  end

end
