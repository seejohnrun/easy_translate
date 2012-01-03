require File.dirname(__FILE__) + '/easy_translate/detection'
require File.dirname(__FILE__) + '/easy_translate/translation'

module EasyTranslate

  autoload :Request, File.dirname(__FILE__) + '/easy_translate/request'
  autoload :VERSION, File.dirname(__FILE__) + '/easy_translate/version'

  extend Detection # Language Detection
  extend Translation # Language Translation

  def self.api_key=(api_key)
    @api_key = api_key
  end

  def self.api_key
    @api_key
  end

end
