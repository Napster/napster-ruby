module Napster
  module Models
    # Profile model
    class Profile
      ATTRIBUTES = [:id,
                    :real_name,
                    :screen_name,
                    :bio,
                    :location,
                    :gender,
                    :visibility,
                    :type,
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
                    :avatar_version,
                    :links].freeze

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
        arg[:data].map do |profile|
          Profile.new(data: profile, client: @client)
        end
      end
    end
  end
end
