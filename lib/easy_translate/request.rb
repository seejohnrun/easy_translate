require 'net/http'
require 'net/https'
require 'uri'

module EasyTranslate

  class Request

    # Body, blank by default
    # @return [String] The body for this request
    def body
      ''
    end

    # The path for the request
    # @return [String] The path for this request
    def path
      raise NotImplementedError.new('path is not implemented')
    end

    # The base params for a request
    # @return [Hash] a hash of the base parameters for any request
    def params
      params = {}
      params[:key] = EasyTranslate.api_key if EasyTranslate.api_key
      params[:prettyPrint] = 'false' # eliminate unnecessary overhead
      params
    end

    # Perform the given request
    # @return [String] The response String
    def perform_raw
      # Get the URI
      uri = URI.parse("https://www.googleapis.com#{path}?#{param_s}")
      # Open the HTTP object
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      # Construct the request
      request = Net::HTTP::Post.new(uri.path)
      request.add_field('X-HTTP-Method-Override', 'GET')
      request.set_form_data body
      # Fire and return
      response = http.request(request)
      response.body
    end

    private

    # Stringify the params
    # @return [String] The params as a string
    def param_s
      params.map do |k, v|
        "#{k}=#{v}" unless v.nil?
      end.compact.join('&')
    end

  end

end
