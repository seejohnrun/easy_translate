require 'yaml'

module EasyTranslate

  module Catalog
    
    # Translate a Rails Language Catalog into one or more languages
    #
    # @param [String] catalog - the full path to a language catalog to translate.
    # @param [String, splat] languages - a splat array of language codes to translate.
    #
    def translate_catalog(catalog_file, *languages)
      # Open the catalog
      catalog_hash = YAML::load(File.open catalog_file)

      # Traverse the Hiearchy, and translate as we go
      languages.each { |language|
        # Get the source language
        source_language = catalog_hash.keys.first
        
        translated_hash = { language => translate_hash(catalog_hash[source_language], source_language, target_language) }
      
        translated_file = File.new(
          catalog_file.gsub(Regexp.new("#{source_language}\."), "#{language}."), 
          File::CREAT|File::TRUNC|File::RDWR, 
          0644)
      
        # Write out the translation
        translated_file << translated_hash.to_yaml
        translated_file.close
      }
    end
    
    protected
    
    # Return a translated Hash by recursing through a source
    # Hash.
    def translate_hash(hash, source_language, target_language)
      translated_hash = {}
      hash.each { |key, value|
        translated_hash[key] = 
          if value.kind_of? Hash
            translate_hash(value, target_language)
          else
            self.translate value, :from => source_language.to_sym, :to => target_language.to_sym
          end
      }
    end
    
  end
end
