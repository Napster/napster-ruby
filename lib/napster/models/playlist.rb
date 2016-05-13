module Napster
  module Models
    # Playlist model
    class Playlist
      ATTRIBUTES = [:type,
                    :id,
                    :name,
                    :modified,
                    :href,
                    :privacy,
                    :images,
                    :description,
                    :favorite_count,
                    :free_play_compliant].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      attr_accessor :client

      def initialize(arg)
        @client = arg[:client] if arg[:client]
        return unless arg[:data]

        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[:data][attribute.to_s.camel_case_lower])
        end
      end

      def self.collection(arg)
        arg[:data].map do |playlist|
          Playlist.new(data: playlist, client: @client)
        end
      end

      # Top level methods

      def playlists_of_the_day
        response = @client.get('/playlists')
        Playlist.collection(data: response['playlists'])
      end

      def featured
        response = @client.get('/playlists/featured')
        Playlist.collection(data: response['playlists'])
      end

      def find(id)
        e = 'Invalid playlist id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :playlist)
        response = @client.get("/playlists/#{id}")
        Playlist.new(data: response['playlists'].first, client: @client)
      end

      # Instance methods

      def tracks(params)
        hash = { params: params }
        response = @client.get("/playlists/#{@id}/tracks", hash)
        Track.collection(data: response['tracks'])
      end

      def tags
        response = @client.get("/playlists/#{@id}/tags")
        Tag.collection(data: response['tags'])
      end

      # /me

      def all(params)
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/library/playlists', get_options)
        Playlist.collection(data: response['playlists'])
      end
    end
  end
end
