module EasyTranslate

  require 'yaml'
  
  class LocaleBase

    # Initialize a new LocaleBase for translating
    # locale files
    #
    # +hash+ The object to convert
    def initialize(hash = [])
      @original = hash
    end

    def convert(options = {})

      tracker = LocaleBaseTracker.new
      
      # place track tokens
      # translate all of them
      # and then replace the tokens with their string equivelants
      # this is inefficient, but we can't make in place edits
      # so i'm not sure if there's a better way (TODO think of a better way)

      # we use divs here instead of spans so that google doesn't mess us up
      # by combining spans on requests
      @created = crazy_walk(@original) do |obj|
        obj.gsub!(/\{\{([^\}]+)\}\}/, '<div class="notranslate">\1</div>')
        # insert trackers
        tracker.track(obj)
      end

      tracker.translate_all(options)

      # TODO everything is okay up until this point, and then the
      # spacing gets all mucky - might be with the regex, or might be the replacement
      # stripping
      @created = crazy_walk(@created) do |obj|
        obj = tracker.retrieve(obj) if obj.is_a?(TrackToken)
        # remove spans
        # whitespace split also needed cause google messess with our shit
        obj.gsub!(/<div\sclass=\"notranslate\">([^<]+)<\/div>/, '{{\1}}')
        obj
      end
      
    end

    private

    # nice little recursive walker
    def crazy_walk(obj, &block)
      if obj.is_a?(Array)
        obj.map { |item| crazy_walk(item, &block) }
      elsif obj.is_a?(Hash)
        hash = Hash.new
        obj.each_pair { |key, value| hash[key] = crazy_walk(value, &block) }
        hash
      else
        yield obj
      end
    end
    
  end

  # VVV this is pretty awesome
  
  # analyze performance implications
  # TODO consider using a hash instead of any array - may have performance help
  # on many duplicates in yaml file - is that a use case that's valid?
  # is there a better structure?
  class LocaleBaseTracker

    def initialize
      @tracking_array = []
    end

    # translate every token
    # TODO make translate! in easy translate
    # TODO move out of this class and into the Base**
    def translate_all(options)
      @tracking_array = EasyTranslate.translate(@tracking_array, options.merge(:html => true))
    end
    
    def track(value)
      @tracking_array << value
      TrackToken.new(self, @tracking_array.size - 1)
    end

    def retrieve(token)
      @tracking_array[token.position]
    end

  end

  class TrackToken

    attr_reader :position
      
    def initialize(tracker, position)
      @tracker = tracker
      @position = position
    end

    def to_s
      @tracker.retrieve(self)
    end
      
  end  
    
end
