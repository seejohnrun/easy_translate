module EasyTranslate

  require 'uri'
  require 'net/http'
  
  require 'rubygems'
  require 'json'
  
  require 'easy_translate/param_builder'
  require 'easy_translate/translator'
  
  API_URL = 'ajax.googleapis.com'
  API_TRANSLATE_PATH = '/ajax/services/language/translate'
  API_DETECT_PATH = '/ajax/services/language/detect'
  API_VERSION = '1.0'

  LANGUAGES = { 'af' => 'afrikaans', 'sq' => 'albanian', 'ar' => 'arabic',
    #'hy' => 'armenian', 'eu' => 'basque', 'az' => 'azerbaijani',
    'be' => 'belarusian', 'bg' => 'bulgarian', 'ca' => 'catalan',
    'zh-CN' => 'chinese_simplified', 'zh-TW' => 'chinese_traditional',
    'hr' => 'croatian', 'cs' => 'czech', 'da' => 'danish', 'nl' => 'dutch',
    'en' => 'english', 'et' => 'estonian', 'tl' => 'filipino', 'fi' => 'finnish',
    'fr' => 'french', 'gl' => 'galician', 'de' => 'german', # 'ka' => 'georgian',
    'el' => 'greek', 'ht' => 'haitian_creole', 'iw' => 'hebrew', 'hi' => 'hindi',
    'hu' => 'hungarian', 'is' => 'icelandic', 'id' => 'indonesian',
    'ga' => 'irish', 'it' => 'italian', 'ja' => 'japanese', 'ko' => 'korean',
    'lv' => 'latvian', 'lt' => 'lithuanian', 'mk' => 'macedonian',
    'ms' => 'malay', 'mt' => 'maltese', 'no' => 'norwegian', 'fa' => 'persian',
    'pl' => 'polish', 'pt' => 'portuguese', 'ro' => 'romanian', 'ru' => 'russian',
    'sr' => 'serbian', 'sk' => 'slovak', 'sl' => 'slovenian', 'es' => 'spanish',
    'sw' => 'swahili', 'sv' => 'swedish', 'th' => 'thai', 'tr' => 'turkish',
    'uk' => 'ukrainian', 'vi' => 'vietnamese', 'cy' => 'welsh', # 'ur' => 'urdu',
    'yi' => 'yiddish' }
    
end
