module Napster
  # The Request class implements a request object used to
  # call Napster API
  class Request
    HOST_URL = 'https://api.rhapsody.com'.freeze

    attr_accessor :faraday

    # Initialize a Faraday client
    # @param options [Hash] May contains api_key, api_secret adn access_token
    # @return [Faraday] Return Faraday object for making API calls
    def initialize(options)
      @faraday = Faraday.new(url: HOST_URL) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter

        if options[:access_token]
          faraday.authorization :Bearer, options[:access_token]
        end

        if options[:api_key] && options[:api_secret]
          faraday.basic_auth(options[:api_key], options[:api_secret])
        end
      end
    end
  end
end
