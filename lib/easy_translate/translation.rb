require 'json'
require File.dirname(__FILE__) + '/request'

module EasyTranslate

  module Translation

    # Translate text
    # @param [String, Array] texts - A single string or set of strings to translate
    # @option options [String, Symbol] :source - The source language (optional)
    # @option options [String, Symbol] :target - The target language (required)
    # @option options [Boolean] :html - Whether or not the supplied string is HTML (optional)
    # @return [String, Array] Translated text or texts
    def translate(texts, options = {})
      request = TranslationRequest.new(texts, options)
      # Turn the response into an array of translations 
      raw = request.perform_raw
      translations = JSON.parse(raw)['data']['translations'].map do |res|
        res['translatedText']
      end
      # And then return, if they only asked for one, only give one back
      request.multi? ? translations : translations.first
    end

    # A convenience class for wrapping a translation request
    class TranslationRequest < EasyTranslate::Request
      
      # Set the texts and options
      # @param [String, Array] texts - the text (or texts) to translate
      # @param [Hash] options - Options to override or pass along with the request
      def initialize(texts, options)
        self.texts = texts
        self.html = options.delete(:html)
        @source = options.delete(:from)
        @target = options.delete(:to)
        raise ArgumentError.new('No target language provded') unless @target
        raise ArgumentError.new('Support for multiple targets dropped in V2') if @target.is_a?(Array)
        if options
          @options = options
          if replacement_api_key = @options.delete(:api_key)
            @options[:key] = replacement_api_key
          end
        end
      end

      # The params for this request
      # @return [Hash] the params for the request
      def params
        params = super || {}
        params[:source] = @source unless @source.nil?
        params[:target] = @target unless @target.nil?
        params[:format] = @format unless @format.nil?
        params.merge! @options if @options
        params
      end

      # The path for the request
      # @return [String] The path for the request
      def path
        '/language/translate/v2'
      end

      # The body for the request
      # @return [String] the body for the request, URL escaped
      def body
        @texts.map { |t| "q=#{URI.escape(t)}" }.join '&'
      end

      # Whether or not this was a request for multiple texts
      # @return [Boolean]
      def multi?
        @multi
      end

      private

      # Set the HTML attribute, if true add a format
      # @param [Boolean] b - Whether or not the text supplied iS HTML
      def html=(b)
        @format = b ? 'html' : nil
      end

      # Set the texts for this request
      # @param [String, Array] texts - The text or texts for this request
      def texts=(texts)
        if texts.is_a?(String)
          @multi = false
          @texts = [texts]
        else
          @multi = true
          @texts = texts
        end
      end

    end

  end

end
