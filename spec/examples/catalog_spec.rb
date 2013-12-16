require File.dirname(__FILE__) + '/../spec_helper'
require 'active_support/core_ext/string/strip.rb'

describe EasyTranslate::Catalog do

  before :all do
    # Put generated files in a temporary directory
    FileUtils.mkdir_p "catalog_spec_test"
    
    # Create the test catalogs for two languages
    ['en', 'sp'].each do |lang|
      f_lang = File.new("catalog_spec_test/catalog.#{lang}.yml", "w")
      content = <<-CATALOG.strip_heredoc
      #{lang}:
        section_1:
          item_1:
            this is item 1
        section_2:
          item_2:
            this is item 2
      CATALOG
    
      f_lang << content
      f_lang.close
    end
  end
  
  after :all do
    FileUtils.rm_rf "catalog_spec_test"
  end

  it 'should translate a catalog file into destination language files' do
    EasyTranslate::Translation::TranslationRequest.stub(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"translations":[{"translatedText":"Hallo Welt"}]}}',
      :multi? => false
    }))
    EasyTranslate::translate_catalog!('catalog_spec_test/catalog.en.yml', 'fr', 'de')
    
    File.exists?('catalog_spec_test/catalog.fr.yml').should == true
    File.exists?('catalog_spec_test/catalog.de.yml').should == true
    
    de_translation = YAML::load(File.open 'catalog_spec_test/catalog.de.yml')
    de_translation['de']['section_2']['item_2'].should  == 'Hallo Welt'
  end
  
  it 'should translate a catalog file into destination language without overwiting existing translations' do
    EasyTranslate::Translation::TranslationRequest.stub(:new).and_return(OpenStruct.new({
      :perform_raw => '{"data":{"translations":[{"translatedText":"Hallo Welt"}]}}',
      :multi? => false
    }))
    EasyTranslate::translate_catalog('catalog_spec_test/catalog.en.yml', 'sp')
    File.exists?('catalog_spec_test/catalog.sp.yml').should == true
    
    sp_translation = YAML::load(File.open 'catalog_spec_test/catalog.sp.yml')
    sp_translation['sp']['section_2']['item_2'].should  == 'this is item 2'
  end

end
