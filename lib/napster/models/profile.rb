using StringHelper

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

      def get
        get_options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me', get_options)
        Profile.new(data: response['me'], client: @client)
      end

      def update(body)
        put_options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.put('/me', Oj.dump(body), put_options)
      end
    end
  end
end
