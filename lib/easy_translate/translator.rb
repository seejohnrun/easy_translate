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
    params = base_params(text, options)
    params.add :q, URI.escape(text)
    json = api_call EasyTranslate::API_DETECT_PATH, params, :type => :get
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
    # what type of call is this?
    multi_call = options[:to].class == Array || text.class == Array
    all_multi_call = options[:to].class == Array && text.class == Array
    # translate params if necessary
    to_lang = (options[:to].class == Array) ? options[:to].map { |to| get_language(to) } : get_language(options[:to])
    from_lang = get_language(options[:from])
    # make the call
    params = base_params(text, options)
    params.add :format, (options[:html] ? 'html' : 'text')
    # for each to language, put all of the q's
    to_lang.each do |tol|
      escaped_lang_pair = URI.escape "#{from_lang}|#{tol}"
      # because ruby let's us call .each on a string with newlines
      text = [text] if text.is_a?(String) # sorry, TODO separate
      text.each do |t|
        params.add :q, URI.escape(t)
        params.add :langpair, escaped_lang_pair
      end
    end
    # TODO cleanup    
    # get the proper response and return
    json = api_call EasyTranslate::API_TRANSLATE_PATH, params, :type => :post
    # single argument is returned
    if !multi_call
      single_single(json)
    # array should be returned
    elsif multi_call && !all_multi_call
      single_multiple(json)
    # the big badass case
    else
      multiple_multiple(json, options[:to].size)
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
      per_bucket = responseData.size / translation_count # should always be integer
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
    params = ParamBuilder.new
    params.add :v, API_VERSION
    params.add :user_ip, URI.escape(options[:user_ip]) if options.has_key?(:user_ip)
    params.add :hl, URI.escape(get_language(options[:host_language])) if options.has_key?(:host_language)
    params.add :key, URI.escape(key) if key
    # key is standard - but left to individual methods
    params
  end
  
  # make a call to the api and throw an error on non-200 response
  # TODO expand error handling
  def self.api_call(path, params, options = {:type => :get})
    response = case options[:type]
      when :get ; api_get_call(path, params)
      when :post ; api_post_call(path, params)
      else ; ArgumentError.new('Bad HTTP type')
    end
    # if we got a response, use it - otherwise, fail town
    json = JSON.parse(response) if response
    raise EasyTranslateException.new(json['responseDetails']) unless json && json['responseStatus'] == 200
    json
  end

  def self.api_post_call(path, params)
    http = Net::HTTP.new(EasyTranslate::API_URL)
    response = http.post(path, params.to_s)
    response.body if response
  end
    
  def self.api_get_call(path, params)
    http = Net::HTTP.new(EasyTranslate::API_URL)
    response = http.get("#{path}?#{params.to_s}")
    response.body if response
  end
      
  # a function used to get the lang code of any input.
  # can take -- :english, 'english', :en, 'en'
  def self.get_language(lang)
    lang = lang.to_s
    lang = EasyTranslate::LANGUAGES.include?(lang) ? lang : EasyTranslate::LANGUAGES.index(lang)
    raise ArgumentError.new('please supply a valid language') unless lang
    lang
  end
  
end
