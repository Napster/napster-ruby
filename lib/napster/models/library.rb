module Napster
  module Models
    # Library model
    class Library
      attr_accessor :client

      def initialize(arg)
        @client = arg[:client] if arg[:client]
        return unless arg[:data]
      end

      def artists(params)
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/library/artists', get_options)
        Artist.collection(data: response['artists'], client: @client)
      end
    end
  end
end
