module Napster
  module Resources
    module Metadata
      # Members resources
      #   Makes /members namespaced calls to Napster API
      class MembersResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def find(arg)
          response = @client.get("/members/#{arg}")
          @data = Napster::Models::Member.new(response['members'].first)
          self
        end
      end
    end
  end
end
