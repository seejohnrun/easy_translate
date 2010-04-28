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
  #   string / an array of the translated strings
  def self.translate(text, options)
    # TODO failing because we run options[:to] through get langauge and it strips it to nil
    
    # what type of call is this?
    multi_call = options[:to].class == Array || text.class == Array
    all_multi_call = options[:to].class == Array && text.class == Array
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
    # TODO cleanup    
    # get the proper response and return
    json = api_call path
    # single argument is returned
    if !multi_call
      single_single(json)
    # array should be returned
    elsif multi_call && !all_multi_call
      single_multiple(json)
    # the big badass case
    else
      multiple_multiple(json, options[:to].count)
    end
  end
  
  # an exception indicating something went wrong in EasyTranslate
  class EasyTranslateException < Exception
  end
  
  private

  def self.multiple_multiple(json, translation_count)
    if json['responseData'].class == Hash
      [[json['responseData']['translatedText']]]
    else
      translations = []
      responseData = json['responseData'].map { |r| r['responseData']['translatedText'] }
      per_bucket = responseData.count / translation_count # should always be integer
      0.upto(translation_count - 1) { |i| translations[i] = responseData.slice(i * per_bucket, per_bucket) }
    end
    translations
  end
  
  def self.single_multiple(json)
    if json['responseData'].class == Hash
      [json['responseData']['translatedText']]
    else
      json['responseData'].map { |j| j['responseData']['translatedText'] }
    end
  end
  
  def self.single_single(json)
    json['responseData']['translatedText']
  end
  
  # take in the base parameters for the google translate api
  def self.base_params(text, options)
    raise ArgumentError.new('multiple :from not allowed') if options[:from] && options[:from].class == Array
    raise ArgumentError.new('no string given') if text.empty?
    key =  options[:key] || @api_key || nil
    params = "v=#{API_VERSION}"
    params << '&userip=' << URI.escape(options[:user_ip]) if options.has_key?(:user_ip)
    params << '&hl=' << URI.escape(get_language(options[:host_language])) if options.has_key?(:host_language)
    params << '&key=' << URI.escape(key) if key
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
    lang = LANGUAGES.include?(lang) ? lang : LANGUAGES.index(lang)
    raise ArgumentError.new('please supply a valid language') unless lang
    lang
  end
  
end
