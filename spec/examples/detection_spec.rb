# encoding: UTF-8

require 'spec_helper'

describe EasyTranslate::Detection do

  it 'should return a single if given a single - from doc' do
    expect(EasyTranslate::Detection::DetectionRequest).to receive(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"detections":[[{"language":"en","isReliable":false,"confidence":0.6595744}]]}}',
      :multi? => false
    }))
    lang = EasyTranslate.detect 'Google Translate Rocks'
    expect(lang).to eq('en')
  end

  it 'should return a single with confidence if given a single with confidence - from doc' do
    expect(EasyTranslate::Detection::DetectionRequest).to receive(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"detections":[[{"language":"en","isReliable":false,"confidence":0.6595744}]]}}',
      :multi? => false
    }))
    lang = EasyTranslate.detect 'Google Translate Rocks', :confidence => true
    expect(lang).to eq({ :language => 'en', :confidence => 0.6595744 })
  end

  it 'should return a multiple if given multiple - from doc' do
    expect(EasyTranslate::Detection::DetectionRequest).to receive(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"detections":[[{"language":"en","isReliable":false,"confidence":0.6315789}],[{"language":"zh-CN","isReliable":false,"confidence":1.0}]]}}',
      :multi? => true
    }))
    lang = EasyTranslate.detect ['Hello World', '我姓譚']
    expect(lang).to eq(['en', 'zh-CN'])
  end

  it 'should return a multiple with confidence if given multiple with confidence - from doc' do
    expect(EasyTranslate::Detection::DetectionRequest).to receive(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"detections":[[{"language":"en","isReliable":false,"confidence":0.6315789}],[{"language":"zh-CN","isReliable":false,"confidence":1.0}]]}}',
      :multi? => true
    }))
    lang = EasyTranslate.detect ['Hello World', '我姓譚'], :confidence => true
    expect(lang).to eq([{ :language => 'en', :confidence => 0.6315789 }, { :language => 'zh-CN', :confidence => 1.0 }])
  end

  klass = EasyTranslate::Detection::DetectionRequest
  describe klass do

    describe :path do

      it 'should have a valid path' do
        request = klass.new('abc')
        expect(request.path).not_to be_empty
      end

    end

    describe :body do

      it 'should insert the texts into the body' do
        request = klass.new(['abc', 'def'])
        expect(request.body).to eq('q=abc&q=def')
      end

      it 'should insert the text into the body' do
        request = klass.new('abc')
        expect(request.body).to eq('q=abc')
      end

      it 'should URI escape the body' do
        request = klass.new('%')
        expect(request.body).to eq('q=%25')
      end

    end

    describe :params do

      it 'should use default params' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc')
        expect(request.params[:key]).to eq('abc')
      end

      it 'should allow overriding of params' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :key => 'def')
        expect(request.params[:key]).to eq('def')
      end

      it 'should allow overriding of key as api_key' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :api_key => 'def')
        expect(request.params[:key]).to eq('def')
        expect(request.params[:api_key]).to be_nil
      end

    end

    describe :options do

      it 'should accept timeouts options' do
        request = EasyTranslate::Detection::DetectionRequest.new "test", {}, {:timeout => 1, :open_timeout => 2}
        http = request.send(:http)
        expect(http.open_timeout).to eq(2)
        expect(http.read_timeout).to eq(1)
      end

      it 'should accept ssl options' do
        request = EasyTranslate::Detection::DetectionRequest.new "test", {}, {:ssl => {:verify_depth => 3, :ca_file => 'path/to/ca/file'}}
        http = request.send(:http)
        expect(http.verify_depth).to eq(3)
        expect(http.ca_file).to eq('path/to/ca/file')
      end

      it 'should accept confidence option' do
        request = EasyTranslate::Detection::DetectionRequest.new "test", {:confidence => true}, {}
        expect(request.params[:confidence]).to eq(true)
      end

    end
    
    describe :multi? do

      it 'should be true if multiple are passed' do
        request = klass.new(['abc', 'def'])
        expect(request).to be_multi
      end

      it 'should be true if one is passed, but in an array' do
        request = klass.new(['abc'])
        expect(request).to be_multi
      end

      it 'should be true if one is passed as a string' do
        request = klass.new('abc')
        expect(request).not_to be_multi
      end

    end

  end

end
