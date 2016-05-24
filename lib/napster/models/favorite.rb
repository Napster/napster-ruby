using StringHelper

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

      # /me

      def get(params)
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/favorites', get_options)
        Favorite.collection(data: response['favorites'], client: @client)
      end

      def status(ids)
        get_options = {
          params: {
            ids: ids
          },
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/favorites/status', get_options)
        FavoriteStatus.collection(data: response['status'], client: @client)
      end

      def add(ids)
        post_options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        body = prepare_add_favorites_body(ids)
        @client.post('/me/favorites', Oj.dump(body), post_options)
        status(ids)
      end

      def remove(id)
        delete_options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.delete("/me/favorites/#{id}", delete_options)
        status([id])
      end

      private

      def request_member_favorites(id)
        response = @client.get("/favorites/#{id}/members")
        Member.collection(data: response['members'], client: @client)
      end

      def prepare_add_favorites_body(ids)
        favorites_body = []
        ids.each do |id|
          favorites_body << { id: id }
        end
        { 'favorites' => favorites_body }
      end
    end
  end
end
