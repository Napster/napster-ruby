module Napster
  module Resources
    module Metadata
      # Artists resources
      #   Makes /artists namespaced calls to Napster API
      class ArtistsResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def top
          response = @client.get('/artists/top')
          @data = Napster::Models::Artist.collection(response['artists'])
          self
        end

        def find(arg)
          return find_by_id(arg) if Napster::Moniker.check(arg, :artist)
          find_by_name(arg)
        end

        def find_by_id(id)
          response = @client.get("/artists/#{id}")
          @data = Napster::Models::Artist.new(response['artists'].first)
          self
        end

        def find_all_by_name(name)
          options = {
            params: {
              q: name,
              type: 'artist'
            }
          }
          response = @client.get('/search', options)
          @data = Napster::Models::Artist.collection(response['data'])
          self
        end

        def find_by_name(name)
          @data = find_all_by_name(name).data.first
          self
        end

        #
        # artist singleton methods
        #

        def albums
          response = @client.get("/artists/#{@data.id}/albums")
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end

        def top_albums
          response = @client.get("/artists/#{@data.id}/albums/top")
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end

        def new_albums
          response = @client.get("/artists/#{@data.id}/albums/new")
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end

        def tracks
          response = @client.get("/artists/#{@data.id}/tracks")
          @data = Napster::Models::Track.collection(response['tracks'])
          self
        end

        def top_tracks
          response = @client.get("/artists/#{@data.id}/tracks/top")
          @data = Napster::Models::Track.collection(response['tracks'])
          self
        end
      end
    end
  end
end
