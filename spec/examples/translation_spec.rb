require 'spec_helper'

describe EasyTranslate::Translation do

  it 'should return a single if given a single - from doc' do
    fake_request(
      :perform_raw => '{"data":{"translations":[{"translatedText":"Hallo Welt"}]}}',
      :multi? => false
    )
    trans = EasyTranslate.translate 'Hello world', :to => 'de'
    expect(trans).to eq('Hallo Welt')
  end

  it 'should return a multiple if given multiple - from doc' do
    fake_request(
      :perform_raw => '{"data":{"translations":[{"translatedText": "Hallo Welt"},{"translatedText":"Mein Name ist Jeff"}]}}',
      :multi? => true
    )
    trans = EasyTranslate.translate ['Hello world', 'my name is jeff'], :to => 'de'
    expect(trans).to eq(['Hallo Welt', 'Mein Name ist Jeff'])
  end

  it 'should decode HTML entities in the response' do
    fake_request(
      :perform_raw => '{"data":{"translations":[{"translatedText":"Hallo &#39; &amp; &quot; Welt"}]}}',
      :multi? => false
    )
    trans = EasyTranslate.translate %{Hello ' & " world}, :to => 'de'
    expect(trans).to eq(%{Hallo ' & " Welt})
  end

  describe 'needs api key' do
    before :each do
      if ENV['API_KEY']
        EasyTranslate.api_key = ENV['API_KEY']
      else
        pending 'please provide an API_KEY for this suite'
      end
    end

    it 'should detect simplified chinese as zh-CN' do
      expect(EasyTranslate.translations_available.include?('zh-CN')).to eq(true)
      expect(EasyTranslate.translations_available.include?('zh')).to eq(true)
    end
  end

  def fake_request(hash)
    expect(EasyTranslate::Translation::TranslationRequest).to receive(:new).and_return(OpenStruct.new(hash))
  end

  klass = EasyTranslate::Translation::TranslationRequest
  describe klass do

    describe :path do

      it 'should have a valid path' do
        request = klass.new('abc', :to => 'en')
        expect(request.path).not_to be_empty
      end

    end

    describe :initialize do

      it 'should raise an error when there is no to given' do
        expect do
          req = klass.new('abc', :from => 'en')
        end.to raise_error ArgumentError
      end

      it 'should raise an error when tos are given as an array' do
        expect do
          req = klass.new('abc', :from => 'en', :to => ['es', 'de'])
        end.to raise_error ArgumentError
      end

    end

    describe :params do

      it 'should include from in params if given' do
        req = klass.new('abc', :from => 'en', :to => 'es')
        expect(req.params[:source]).to eq('en')
      end

      it 'should not include from by default' do
        req = klass.new('abc', :to => 'es')
        expect(req.params[:source]).to be_nil
      end

      it 'should include to' do
        req = klass.new('abc', :to => 'es')
        expect(req.params[:target]).to eq('es')
      end

      it 'should not include format by default' do
        req = klass.new('abc', :to => 'es')
        expect(req.params[:format]).to be_nil
      end

      it 'should not include format when given as false' do
        req = klass.new('abc', :html => false, :to => 'es')
        expect(req.params[:format]).to be_nil
      end

      it 'should include format when html is true' do
        req = klass.new('abc', :html => true, :to => 'es')
        expect(req.params[:format]).to eq('html')
      end

      it 'should include format when specified as text' do
        req = klass.new('abc', :format => 'text', :to => 'es')
        expect(req.params[:format]).to eq('text')
      end

      it 'should use default params' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :to => 'es')
        expect(request.params[:key]).to eq('abc')
      end

      it 'should allow overriding of params' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :key => 'def', :to => 'es')
        expect(request.params[:key]).to eq('def')
      end

      it 'should allow overriding of key as api_key' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :api_key => 'def', :to => 'es')
        expect(request.params[:key]).to eq('def')
        expect(request.params[:api_key]).to be_nil
      end

      it 'should be able to supply a language as a string' do
        request = klass.new('abc', :to => 'es')
        expect(request.params[:target]).to eq('es')
      end

      it 'should be able to supply a language as a symbol' do
        request = klass.new('abc', :to => :es)
        expect(request.params[:target]).to eq('es')
      end

      it 'should be able to supply a language as a word' do
        request = klass.new('abc', :to => 'spanish')
        expect(request.params[:target]).to eq('es')
      end

      it 'should be able to supply a language as a word symbol' do
        request = klass.new('abc', :to => :spanish)
        expect(request.params[:target]).to eq('es')
      end

      it 'should fall back when a word is not in the lookup' do
        request = klass.new('abc', :to => 'zzz')
        expect(request.params[:target]).to eq('zzz')
      end

    end

    describe :multi? do

      it 'should be true if multiple are passed' do
        request = klass.new(['abc', 'def'], :to => 'es')
        expect(request).to be_multi
      end

      it 'should be true if one is passed, but in an array' do
        request = klass.new(['abc'], :to => 'es')
        expect(request).to be_multi
      end

      it 'should be true if one is passed as a string' do
        request = klass.new('abc', :to => 'es')
        expect(request).not_to be_multi
      end

    end

    describe :body do

      it 'should insert the texts into the body' do
        request = klass.new(['abc', 'def'], :to => 'es')
        expect(request.body).to eq('q=abc&q=def')
      end

      it 'should insert the text into the body' do
        request = klass.new('abc', :to => 'es')
        expect(request.body).to eq('q=abc')
      end

      it 'should URI escape the body' do
        request = klass.new('%', :to => 'es')
        expect(request.body).to eq('q=%25')
      end

    end

  end

end
