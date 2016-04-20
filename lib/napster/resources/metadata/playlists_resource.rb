module Napster
  module Resources
    module Metadata
      # Playlists resources
      #   Makes /playlists namespaced calls to Napster API
      class PlaylistsResource
        attr_accessor :client, :data

        def initialize(client)
          @client = client
          @data = nil
        end

        def playlists_of_the_day
          response = @client.get('/playlists')
          @data = Napster::Models::Playlist.collection(response['playlists'])
          self
        end

        def featured
          response = @client.get('/playlists/featured')
          @data = Napster::Models::Playlist.collection(response['playlists'])
          self
        end

        def find(id)
          e = 'Invalid playlist id'
          raise ArgumentError, e unless Napster::Moniker.check(id, :playlist)
          response = @client.get("/playlists/#{id}")
          @data = Napster::Models::Playlist.new(response['playlists'].first)
          self
        end

        #
        # playlist singleton methods
        #

        def tracks(params)
          hash = { params: params }
          response = @client.get("/playlists/#{@data.id}/tracks", hash)
          @data = Napster::Models::Track.collection(response['tracks'])
          self
        end

        def tags
          response = @client.get("/playlists/#{@data.id}/tags")
          @data = Napster::Models::Tag.collection(response['tags'])
          self
        end
      end
    end
  end
end
