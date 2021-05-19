require 'spec_helper'

describe EasyTranslate do

  it 'should have LANGUAGES' do
    expect(EasyTranslate::LANGUAGES).to be_a(Hash)
    expect(EasyTranslate::LANGUAGES['en']).to eq('english')
  end

  it 'should have a version' do
    expect(EasyTranslate::VERSION.split('.').length).to eq(3)
  end

end
