module Napster
  module Resources
    module Metadata
      # Albums resources
      #   Makes /albums namespaced calls to Napster API
      class AlbumsResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def new_releases
          response = @client.get('/albums/new')
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end

        def top
          response = @client.get('/albums/top')
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end

        def find(arg)
          return find_by_id(arg) if Napster::Moniker.check(arg, :album)
          find_by_name(arg)
        end

        def find_by_id(id)
          response = @client.get("/albums/#{id}")
          @data = Napster::Models::Album.new(response['albums'].first)
          self
        end

        def find_all_by_name(name)
          options = {
            params: {
              q: name,
              type: 'album'
            }
          }
          response = @client.get('/search', options)
          @data = Napster::Models::Album.collection(response['data'])
          self
        end

        def find_by_name(name)
          @data = find_all_by_name(name).data.first
          self
        end

        #
        # album singleton methods
        #

        def tracks
          response = @client.get("/albums/#{@data.id}/tracks")
          @data = Napster::Models::Track.collection(response['tracks'])
          self
        end

        def similar
          response = @client.get("/albums/#{@data.id}/similar")
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end
      end
    end
  end
end
