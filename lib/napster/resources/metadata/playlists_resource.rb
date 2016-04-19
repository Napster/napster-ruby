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
      end
    end
  end
end
