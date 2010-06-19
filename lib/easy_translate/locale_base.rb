module EasyTranslate

  require 'yaml'
  
  class LocaleBase

    # Initialize a new LocaleBase for translating
    # locale files
    #
    # +yaml+ The object to convert
    def initialize(yaml = [])
      @original = yaml
    end

    def convert(options = {})

      track = LocaleBaseTracker.new
      
      @creation = {}
      tracker = LocaleBaseTracker.new

      walk(@original, String) do |item|
        puts "#{item} is a String"
      end
            
    end

    private

    def walk(arr, look_for, &block)
      arr.each do |item|
        puts item.class
        if item.is_a?(look_for)
          yield(item)
        else
          walk(item, look_for, &block) # keep on keepin on
        end
      end
    end
    
  end

  class LocaleBaseTracker

    def initialize
      @tracking_hash = {}
    end
    
    def track(key, value)
      token = TrackToken.new
      @tracking_hash[token] = value
      token
    end

    class TrackToken
    end
    
  end
    
end
