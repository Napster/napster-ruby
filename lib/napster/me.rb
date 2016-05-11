module Napster
  class Me
    attr_accessor :client

    def initialize(client)
      validate_access_token(client)
      @client = client
    end

    def profile
      get_options = {
        headers: {
          Authorization: 'Bearer ' + @client.access_token,
          'Content-Type' => 'application/json',
          'Accept-Version' => '2.0.0'
        }
      }
      response = @client.get("/me", get_options)
      Napster::Models::Profile.new(data: response['me'], client: @client)
    end

    def update_profile(body)
      put_options = {
        headers: {
          Authorization: 'Bearer ' + @client.access_token,
          'Content-Type' => 'application/json',
          'Accept-Version' => '2.0.0'
        }
      }
      @client.put('/me', Oj.dump(body), put_options)
    end

    private

    def validate_access_token(client)
      raise 'The client is missing access_token' unless client.access_token
    end
  end
end
