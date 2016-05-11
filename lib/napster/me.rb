module Napster
  module Me
    def self.profile
      response = @client.get("/me")
      Profile.new(data: response['me'], client: @client)
    end
  end
end
