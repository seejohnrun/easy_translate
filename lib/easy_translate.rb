require File.dirname(__FILE__) + '/easy_translate/detection'
require File.dirname(__FILE__) + '/easy_translate/translation'

module EasyTranslate

  autoload :EasyTranslateException, File.dirname(__FILE__) + '/easy_translate/easy_translate_exception'
  autoload :Request, File.dirname(__FILE__) + '/easy_translate/request'

  autoload :LANGUAGES, File.dirname(__FILE__) + '/easy_translate/languages'
  autoload :VERSION, File.dirname(__FILE__) + '/easy_translate/version'

  extend Detection # Language Detection
  extend Translation # Language Translation

  class << self
    attr_accessor :api_key
  end

end
