module Napster
  module Models
    # Favorite model
    class Favorite
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
        arg[:data].map do |favorite|
          Favorite.new(data: favorite, client: @client)
        end
      end

      # Top level methods

      def members_who_favorited_albums(id)
        e = 'Invalid playlist id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :album)
        response = @client.get("/albums/#{id}/favorited/members")
        Member.collection(data: response['members'], client: @client)
      end

      def members_who_favorited_artists(id)
        e = 'Invalid playlist id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :artist)
        response = @client.get("/artists/#{id}/favorited/members")
        Member.collection(data: response['members'], client: @client)
      end

      def member_favorites_for(id)
        request_member_favorites(id)
      end

      private

      def request_member_favorites(id)
        response = @client.get("/favorites/#{id}/members")
        Member.collection(data: response['members'], client: @client)
      end
    end
  end
end
