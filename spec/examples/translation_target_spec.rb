require 'spec_helper'

klass = EasyTranslate::TranslationTarget::TranslationTargetRequest
describe klass do

  describe :params do

    it 'should include target in params if given' do
      req = klass.new('en')
      expect(req.params[:target]).to eq('en')
    end

    it 'should not include target by default' do
      req = klass.new
      expect(req.params[:target]).to be_nil
    end

    it 'should use default key' do
      EasyTranslate.api_key = 'abc'
      request = klass.new('en')
      expect(request.params[:key]).to eq('abc')
    end

    it 'should allow overriding of params' do
      EasyTranslate.api_key = 'abc'
      request = klass.new('en', :key => 'def')
      expect(request.params[:key]).to eq('def')
    end

    it 'should allow overriding of key as api_key' do
      EasyTranslate.api_key = 'abc'
      request = klass.new('abc', :api_key => 'def', :to => 'es')
      expect(request.params[:key]).to eq('def')
      expect(request.params[:api_key]).to be_nil
    end

  end

end
