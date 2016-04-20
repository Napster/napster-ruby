module Napster
  module Resources
    module Metadata
      # Tags resources
      #   Makes /tags namespaced calls to Napster API
      class TagsResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def all
          response = @client.get('/tags')
          @data = Napster::Models::Tag.collection(response['tags'])
          self
        end

        def featured
          response = @client.get('/tags/featured')
          @data = Napster::Models::Tag.collection(response['tags'])
          self
        end

        def find(id)
          e = 'Invalid tag id'
          raise ArgumentError, e unless Napster::Moniker.check(id, :tag)
          response = @client.get("/tags/#{id}")
          @data = Napster::Models::Tag.new(response['tags'].first)
          self
        end
      end
    end
  end
end
