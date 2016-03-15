module Napster
  # Request class implements a request object used to
  # call Napster API
  class Request
    HOST_URL = 'https://api.rhapsody.com'.freeze

    attr_accessor :faraday

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
