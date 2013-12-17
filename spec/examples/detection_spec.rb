require 'spec_helper'

describe EasyTranslate::Detection do

  it 'should return a single if given a single - from doc' do
    EasyTranslate::Detection::DetectionRequest.stub!(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"detections":[[{"language":"en"}]]}}',
      :multi? => false
    }))
    lang = EasyTranslate.detect 'Google Translate Rocks'
    lang.should == 'en'
  end

  klass = EasyTranslate::Detection::DetectionRequest
  describe klass do

    describe :path do

      it 'should have a valid path' do
        request = klass.new('abc')
        request.path.should_not be_empty
      end

    end

    describe :body do

      it 'should insert the texts into the body' do
        request = klass.new(['abc', 'def'])
        request.body.should == 'q=abc&q=def'
      end

      it 'should insert the text into the body' do
        request = klass.new('abc')
        request.body.should == 'q=abc'
      end

      it 'should URI escape the body' do
        request = klass.new('%')
        request.body.should == 'q=%25'
      end

    end

    describe :params do

      it 'should use default params' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc')
        request.params[:key].should == 'abc'
      end

      it 'should allow overriding of params' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :key => 'def')
        request.params[:key].should == 'def'
      end

      it 'should allow overriding of key as api_key' do
        EasyTranslate.api_key = 'abc'
        request = klass.new('abc', :api_key => 'def')
        request.params[:key].should == 'def'
        request.params[:api_key].should be_nil
      end

    end

    describe :options do

      it 'should accept timeouts options' do
        request = EasyTranslate::Detection::DetectionRequest.new "test", {}, {:timeout => 1, :open_timeout => 2}
        http = request.send(:http)
        http.open_timeout.should == 2
        http.read_timeout.should == 1
      end

      it 'should accept ssl options' do
        request = EasyTranslate::Detection::DetectionRequest.new "test", {}, {:ssl => {:verify_depth => 3, :ca_file => 'path/to/ca/file'}}
        http = request.send(:http)
        http.verify_depth.should == 3
        http.ca_file.should == 'path/to/ca/file'
      end

    end
    
    describe :multi? do

      it 'should be true if multiple are passed' do
        request = klass.new(['abc', 'def'])
        request.should be_multi
      end

      it 'should be true if one is passed, but in an array' do
        request = klass.new(['abc'])
        request.should be_multi
      end

      it 'should be true if one is passed as a string' do
        request = klass.new('abc')
        request.should_not be_multi
      end

    end

  end

end
