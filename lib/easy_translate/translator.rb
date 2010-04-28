module EasyTranslate
  
  attr_writer :api_key

  # Detect the language of a given string of text.
  # Optional parameters:
  #   :key - API key for google language (defaults to nil)
  #   :host_language - language (defaults to 'en')
  #   :user_ip - the ip of the end user - will help not be mistaken for abuse
  # Required Parameters:
  #   the text to detect the language for
  # Returns:
  #   the string language code (ie: 'en') of the language
  # Note:
  #   This API (since it focuses more on tranlations/ease, does not return 
  #   confidence ratings)
  def self.detect(text, options = {})
    json = api_call "#{API_DETECT_PATH}?#{base_params(text, options)}&q=#{URI.escape text}"
    json['responseData']['language']
  end
    
  # Translate a string using Google Translate
  # Optional parameters:
  #   :key - API key for google language (defaults to nil)
  #   :host_language - language (defaults to 'en') (symbol/string)
  #   :user_ip - the ip of the end user - will help not be mistaken for abuse
  #   :from - the language to translate from (symbol/string)
  #   :html - boolean indicating whether the text you're translating is HTML or plaintext
  # Required Parameters:
  #   the text to translate
  #   :to - the language to translate to (symbol/string)
  # Returns:
  #   the translated string
  def self.translate(text, options)
    # translate params if necessary
    to_lang = get_language(options[:to])
    from_lang = get_language(options[:from])
    # make the call
    path = "#{API_TRANSLATE_PATH}?#{base_params(text, options)}"
    path << '&format=' << (options[:html] ? 'html' : 'text')
    path << '&q=' << URI.escape(text)
    path << '&langpair=' << URI.escape("#{from_lang}|#{to_lang}")
    # get the proper response and return
    json = api_call path
    json['responseData']['translatedText']
  end
  
  # Translate batches of string using Google Translate
  # Optional parameters:
  #   :key - API key for google language (defaults to nil)
  #   :host_language - language (defaults to 'en') (symbol/string)
  #   :user_ip - the ip of the end user - will help not be mistaken for abuse
  #   :from - the language to translate from (symbol/string)
  #   :html - boolean indicating whether the text you're translating is HTML or plaintext
  # Required Parameters:
  #   the text(s) to translate (string/array)
  #   :to - the language(s) to translate to (symbol/string/array)
  # Returns:
  #   an array of the translated strings
  def self.translate_batch(text, options)
    # translate params if necessary
    to_lang = (options[:to].class == Array) ? options[:to].map { |to| get_language(to) } : get_language(options[:to])
    from_lang = get_language(options[:from])
    # make the call
    path = "#{API_TRANSLATE_PATH}?#{base_params(text, options)}"
    path << '&format=' << (options[:html] ? 'html' : 'text')
    # for each to language, put all of the q's
    to_lang.each do |tol|
      escaped_lang_pair = URI.escape "#{from_lang}|#{tol}"
      text.each do |t| 
        path << "&q=#{URI.escape t}"
        path << "&langpair=#{escaped_lang_pair}"
      end
    end
    # get the proper response and return
    json = api_call path
    if json['responseData'].class == Array
      translations = json['responseData'].map { |j| j['responseData']['translatedText'] }
    else
      [json['responseData']['translatedText']]
    end
  end
  
  # an exception indicating something went wrong in EasyTranslate
  class EasyTranslateException < Exception
  end
  
  private
  
  # take in the base parameters for the google translate api
  def self.base_params(text, options)
    raise ArgumentError.new('multiple :from not allowed') if options[:from] && options[:from].class == Array
    raise ArgumentError.new('no string given') if text.empty?
    key =  options[:key] || @api_key || nil
    params = "v=#{API_VERSION}"
    params << '&userip=' << options[:user_ip] if options.has_key?(:user_ip)
    params << '&hl=' << get_language(options[:host_language]) if options.has_key?(:host_language)
    params << '&key=' << key if key
    # key is standard - but left to individual methods
    params
  end
  
  # make a call to the api and throw an error on non-200 response
  # TODO - expand error handling
  def self.api_call(path)
    response = Net::HTTP.get(API_URL, path)
    json = JSON.parse(response)
    raise EasyTranslateException.new(json['responseDetails']) unless json['responseStatus'] == 200
    json
  end
  
  # a function used to get the lang code of any input.
  # can take -- :english, 'english', :en, 'en'
  def self.get_language(lang)
    lang = lang.to_s
    LANGUAGES.include?(lang) ? lang : LANGUAGES.index(lang)
  end
  
end