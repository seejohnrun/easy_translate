module EasyTranslate
  
  require 'easy_translate/translator'
  
  require 'uri'
  require 'net/http'
  
  require 'rubygems'
  require 'json'
  
  API_URL = 'ajax.googleapis.com'
  API_TRANSLATE_PATH = '/ajax/services/language/translate'
  API_DETECT_PATH = '/ajax/services/language/detect'
  API_VERSION = '1.0'
  
  LANGUAGES = { 'tr' => 'turkish', 'sv' => 'swedish', 'km' => 'khmer', 
    'mk' => 'macedonian', 'chr' => 'cherokee', 'si' => 'sinhalese', 
    'zh-cn' => 'chinese_simplified', 'fi' => 'finnish', 'lo' => 'laothian', 
    'da' => 'danish', 'th' => 'thai', 'sk' => 'slovak', 'sq' => 'albanian', 
    'ms' => 'malay', 'no' => 'norwegian', '' => 'unknown', 'cy' => 'welsh', 
    'be' => 'belarusian', 'am' => 'amharic', 'ca' => 'catalan', 
    'zh' => 'chinese', 'id' => 'indonesian', 'ta' => 'tamil', 
    'fa' => 'persian', 'zh-tw' => 'chinese_traditional', 'uz' => 'uzbek', 
    'sw' => 'swahili', 'ja' => 'japanese', 'kk' => 'kazakh', 
    'gl' => 'galician', 'ps' => 'pashto', 'lv' => 'latvian', 'te' => 'telugu',
    'sa' => 'sanskrit', 'kn' => 'kannada', 'af' => 'afrikaans', 
    'ka' => 'georgian', 'it' => 'italian', 'mr' => 'marathi', 'ug' => 'uighur',
    'ro' => 'romanian', 'nl' => 'dutch', 'gu' => 'gujarati', 
    'eo' => 'esperanto', 'uk' => 'ukrainian', 'ru' => 'russian', 
    'ky' => 'kyrgyz', 'ga' => 'irish', 'tl' => 'tagalog', 'sr' => 'serbian', 
    'pa' => 'punjabi', 'mt' => 'maltese', 'ne' => 'nepali', 'or' => 'oriya', 
    'eu' => 'basque', 'dv' => 'dhivehi', 'sl' => 'slovenian', 
    'pl' => 'polish', 'el' => 'greek', 'ku' => 'kurdish', 'de' => 'german', 
    'iw' => 'hebrew', 'sd' => 'sindhi', 'et' => 'estonian', 'gn' => 'guarani',
    'is' => 'icelandic', 'bn' => 'bengali', 'tl' => 'filipino', 
    'bo' => 'tibetan', 'es' => 'spanish', 'fr' => 'french', 
    'hy' => 'armenian', 'bg' => 'bulgarian', 'lt' => 'lithuanian', 
    'mn' => 'mongolian', 'az' => 'azerbaijani', 'yi' => 'yiddish', 
    'ur' => 'urdu', 'en' => 'english', 'pt-pt' => 'portuguese', 
    'vi' => 'vietnamese', 'ml' => 'malayalam', 'ar' => 'arabic', 
    'bh' => 'bihari', 'iu' => 'inuktitut', 'my' => 'burmese', 
    'hu' => 'hungarian', 'ko' => 'korean', 'tg' => 'tajik', 'cs' => 'czech',
    'hi' => 'hindi', 'hr' => 'croatian' }
  
end