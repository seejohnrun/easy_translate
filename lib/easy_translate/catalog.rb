require 'yaml'

module EasyTranslate

  module Catalog
    
    # Create a Rails Language Catalogs (locale dictionary) for one or more languages
    # by translating a source Catalog.
    #
    # @param [String] catalog_filename - the full path to a language catalog to translate.
    # @param [String, splat] languages - a splat array of google language codes to translate.
    #
    def translate_catalog!(catalog_filename, *languages)
      _translate_catalog(catalog_filename, true, *languages)
    end

    # Create or Update a Rails Language Catalog (locale dictionary) for one or more 
    # languages by translating a source catalog.
    #
    # Updates are non-destructive in that they do not replace any existing translations
    # in the translated files.
    #
    # @param [String] catalog_filename - the full path to a language catalog to translate.
    # @param [String, splat] languages - a splat array of google language codes to translate.
    #
    def translate_catalog(catalog_filename, *languages)
      _translate_catalog(catalog_filename, false, *languages)
    end
      
    private
    
    # Translate the language in a catalog (locale ditionary) into one or more languages.
    # Write the output to files derived from the source catalog's filename by replacing
    # the google language code.
    #
    # @param [String] catalog_filename - the full path to a language catalog to translate.
    # @param [Boolean] allow_overwrites - replace any existing translations in the destination
    # translations with the translation from the source catalog.
    # @param [String, splat] languages - a splat array of google language codes to translate.
    #
    def _translate_catalog(catalog_filename, allow_overwrites, *languages)
      catalog_hash  = YAML::load(File.open catalog_filename)
      from_language = catalog_hash.keys.first

      languages.each { |to_language|
        translated_hash = init_to_hash(catalog_filename, from_language, to_language)

        # Start translating after the initial node because it contains the lanuage identifier
        translate_hash(catalog_hash[from_language], translated_hash[to_language], from_language, to_language, allow_overwrites)

        write_translated_file(get_to_filename(catalog_filename, from_language, to_language), translated_hash)
      }
    end
    
    # Generate the 'to' filename by replacing the 'from' language code
    # in the 'from' filename.
    def get_to_filename(from_filename, from_language, to_language)
      from_filename.gsub(Regexp.new("#{from_language}\."), "#{to_language}.")
    end
    
    # Initialize the Hash used for the destination 'to_language'. If a
    # file exists for the 'to_language' use that, otherwise create a
    # starter Hash with the initial node for the 'to_language'.
    def init_to_hash(from_filename,from_language, to_language)
      to_filename = get_to_filename(from_filename, from_language, to_language)
      if File.exists? to_filename
        YAML::load(File.open to_filename)
      else
        { to_language => {} }
      end
    end
    
    # Create or overwrite the translated Catalog with owner rw and
    # group|other as read only.
    def write_translated_file(filename, translated_hash)
      translated_file = File.new(filename, File::CREAT|File::TRUNC|File::RDWR, 0644)    
      translated_file << translated_hash.to_yaml
      translated_file.close
    end
    
    # Update the translated Hash with translations by recursing through a source
    # Hash of message keys and sub-hashes.
    def translate_hash(from_hash, to_hash, from_language, to_language, allow_overwrites)
      from_hash.each { |key, value|
        if value.kind_of? Hash
          to_hash[key] = {} unless to_hash[key]
          translate_hash(value, to_hash[key], from_language, to_language, allow_overwrites)
        elsif to_hash[key].nil? or allow_overwrites
          to_hash[key] = self.translate(value, :from => from_language.to_sym, :to => to_language.to_sym)
        end
      }
    end

  end
end
