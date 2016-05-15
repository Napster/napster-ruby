module Napster
  module Models
    # Following model
    class Following
      attr_accessor :client

      def initialize(arg)
        @client = arg[:client] if arg[:client]
      end

      def members(params)
        options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/following', options)
        Member.collection(data: response['members'], client: @client)
      end

      def by?(guids)
        path = "/me/following/#{guids.join(',')}"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.get(path, options)['members']
      end
    end
  end
end
