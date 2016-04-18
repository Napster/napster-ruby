module Napster
  module Resources
    module Metadata
      # Artists resources
      #   Makes /artists namespaced calls to Napster API
      class ArtistsResource
        attr_accessor :client

        def initialize(client)
          @client = client
        end

        def top
          response = @client.get('/artists/top')
          Napster::Models::Artist.collection(response['artists'])
        end
      end
    end
  end
end
