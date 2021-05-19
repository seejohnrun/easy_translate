require 'spec_helper'

describe EasyTranslate::Request do

  describe :path do

    it 'should raise a NotImplementedError on this base class' do
      request = EasyTranslate::Request.new
      expect do
        request.path
      end.to raise_error NotImplementedError
    end

  end

  describe :body do

    it 'should be blank by default' do
      request = EasyTranslate::Request.new
      expect(request.body).to be_empty
    end

  end

  describe :params do

    it 'should include the key if given at the base' do
      EasyTranslate.api_key = 'abc'
      request = EasyTranslate::Request.new
      expect(request.params[:key]).to eq('abc')
    end

    it 'should turn off prettyPrint' do
      request = EasyTranslate::Request.new
      expect(request.params[:prettyPrint]).to eq('false')
    end

  end

  describe :param_s do

    it 'should skip nil parameters' do
      request = EasyTranslate::Request.new
      expect(request).to receive(:params).and_return({ :something => nil })
      expect(request.send(:param_s)).to be_empty
    end

  end

end
