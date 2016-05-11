module Napster
  class Me
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def profile
      response = @client.get("/me")
      Napster::Models::Profile.new(data: response['me'], client: @client)
    end
  end
end
