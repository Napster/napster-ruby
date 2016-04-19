module Napster
  module Resources
    module Metadata
      # Genres resources
      #   Makes /genres namespaced calls to Napster API
      class GenresResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def all
          response = @client.get('/genres')
          @data = Napster::Models::Genre.collection(response['genres'])
          self
        end

        def find(arg)
          e_msg = 'Invalid genre id'
          raise ArgumentError, e_msg unless Napster::Moniker.check(arg, :genre)
          find_by_id(arg)
        end

        def find_by_id(id)
          response = @client.get("/genres/#{id}")
          @data = Napster::Models::Genre.new(response['genres'].first)
          self
        end

        #
        # genre singleton methods
        #

        def top_artists
          response = @client.get("/genres/#{@data.id}/artists/top")
          @data = Napster::Models::Artist.collection(response['artists'])
          self
        end

        def top_albums
          response = @client.get("/genres/#{@data.id}/albums/top")
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end

        def top_tracks
          response = @client.get("/genres/#{@data.id}/tracks/top")
          @data = Napster::Models::Track.collection(response['tracks'])
          self
        end

        def new_releases
          response = @client.get("/genres/#{@data.id}/albums/new")
          @data = Napster::Models::Album.collection(response['albums'])
          self
        end
      end
    end
  end
end
