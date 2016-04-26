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
          Napster::Models::Artist.collection({ data: response['artists'], client: @client })
        end

        def find(arg)
          return find_by_id(arg) if Napster::Moniker.check(arg, :artist)
          find_by_name(arg)
        end

        def find_by_id(id)
          response = @client.get("/artists/#{id}")
          Napster::Models::Artist.new({ data: response['artists'].first, client: @client })
        end

        def find_all_by_name(name)
          options = {
            params: {
              q: name,
              type: 'artist'
            }
          }
          response = @client.get('/search', options)
          Napster::Models::Artist.collection({ data: response['data'], client: @client })
        end

        def find_by_name(name)
          find_all_by_name(name).first
        end
      end
    end
  end
end
