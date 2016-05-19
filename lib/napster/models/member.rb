using StringHelper

module Napster
  module Models
    # Member model
    class Member
      ATTRIBUTES = [:type,
                    :id,
                    :real_name,
                    :screen_name,
                    :bio,
                    :location,
                    :genre,
                    :visibility,
                    :href,
                    :favorite_albums_count,
                    :favorite_artists_count,
                    :favorite_tracks_count,
                    :playlists_total_count,
                    :playlists_published_count,
                    :stations_count,
                    :radio_count,
                    :follower_count,
                    :following_count,
                    :avatar,
                    :avatar_id,
                    :default_avatar,
                    :avatar_version].freeze

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
        arg[:data].map do |member|
          Member.new(data: member, client: @client)
        end
      end

      # Top level methods

      def find(arg)
        response = @client.get("/members/#{arg}")
        Member.new(data: response['members'].first, client: @client)
      end

      def screenname_available?(screenname)
        response = @client.get("/screenname/#{screenname}")
        response['screenName'].nil?
      end

      # TODO: .avatar

      def playlists(params)
        request_playlists(@id, params)
      end

      def playlists_for(guid, params)
        request_playlists(guid, params)
      end

      def favorites(params)
        request_favorites(@id, params)
      end

      def favorites_for(guid, params)
        request_favorites(guid, params)
      end

      def favorite_playlists(params)
        request_favorite_playlists(@id, params)
      end

      def favorite_playlists_for(guid, params)
        request_favorite_playlists(guid, params)
      end

      def chart(params)
        request_chart(@id, params)
      end

      def chart_for(guid, params)
        request_chart(guid, params)
      end

      private

      def request_playlists(guid, params)
        options = { params: params }
        response = @client.get("/members/#{guid}/library/playlists", options)
        Playlist.collection(data: response['playlists'], client: @client)
      end

      def request_favorites(guid, params)
        options = { params: params }
        response = @client.get("/members/#{guid}/favorites", options)
        Favorite.collection(data: response['favorites'], client: @client)
      end

      def request_favorite_playlists(guid, params)
        options = { params: params }
        response = @client.get("/members/#{guid}/favorites/playlists", options)
        Playlist.collection(data: response['playlists'], client: @client)
      end

      def request_chart(guid, params)
        options = { params: params }
        response = @client.get("/members/#{guid}/charts", options)
        Chart.collection(data: response['charts'], client: @client)
      end
    end
  end
end
