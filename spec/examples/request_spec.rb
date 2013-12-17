require 'spec_helper'

describe EasyTranslate::Request do

  describe :path do

    it 'should raise a NotImplementedError on this base class' do
      request = EasyTranslate::Request.new
      lambda do
        request.path
      end.should raise_error NotImplementedError
    end

  end

  describe :body do

    it 'should be blank by default' do
      request = EasyTranslate::Request.new
      request.body.should be_empty
    end

  end

  describe :params do

    it 'should include the key if given at the base' do
      EasyTranslate.api_key = 'abc'
      request = EasyTranslate::Request.new
      request.params[:key].should == 'abc'
    end

    it 'should turn off prettyPrint' do
      request = EasyTranslate::Request.new
      request.params[:prettyPrint].should == 'false'
    end

  end

  describe :param_s do

    it 'should skip nil parameters' do
      request = EasyTranslate::Request.new
      request.stub!(:params).and_return({ :something => nil })
      request.send(:param_s).should be_empty
    end

  end

end
