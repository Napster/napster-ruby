using StringHelper

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

      def playlists_of_the_day(params)
        response = @client.get('/playlists', params: params)
        Playlist.collection(data: response['playlists'], client: @client)
      end

      def featured(params)
        response = @client.get('/playlists/featured', params: params)
        Playlist.collection(data: response['playlists'], client: @client)
      end

      def find(id)
        e = 'Invalid playlist id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :playlist)

        return authenticated_find(id) if @client.access_token

        response = @client.get("/playlists/#{id}")
        Playlist.new(data: response['playlists'].first, client: @client)
      end

      # Instance methods

      def tracks(params)
        return authenticated_tracks(params) if @client.access_token

        hash = { params: params }
        response = @client.get("/playlists/#{@id}/tracks", hash)
        Track.collection(data: response['tracks'], client: @client)
      end

      def tags
        return authenticated_tags if @client.access_token

        response = @client.get("/playlists/#{@id}/tags")
        Tag.collection(data: response['tags'], client: @client)
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

      def authenticated_find(playlist_id)
        path = "/me/library/playlists/#{playlist_id}"
        get_options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, get_options)
        return nil if response['playlists'].empty?

        Playlist.new(data: response['playlists'].first, client: @client)
      end

      def authenticated_tracks(params)
        path = "/me/library/playlists/#{@id}/tracks"
        options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, options)
        return [] if response['tracks'].empty?

        Track.collection(data: response['tracks'], client: @client)
      end

      def create(playlist_hash)
        body = Oj.dump('playlists' => playlist_hash)
        path = '/me/library/playlists'
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.post(path, body, options)
        Playlist.new(data: response['playlists'].first, client: @client)
      end

      def update(playlist_id, playlist_hash)
        body = Oj.dump('playlists' => playlist_hash)
        path = "/me/library/playlists/#{playlist_id}"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.put(path, body, options)
        Playlist.new(data: response['playlists'].first, client: @client)
      end

      def delete(playlist_id)
        path = "/me/library/playlists/#{playlist_id}"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.delete(path, options)
      end

      def set_private(playlist_id, boolean)
        e = 'The argument should be a boolean value.'
        raise ArgumentError, e unless [true, false].include?(boolean)

        privacy_value = boolean ? 'private' : 'public'
        body = Oj.dump('privacy' => privacy_value)
        path = "/me/library/playlists/#{playlist_id}/privacy"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.put(path, body, options)
      end

      def add_tracks(playlist_id, tracks)
        tracks = tracks.map { |track| { 'id' => track } }
        body = Oj.dump('tracks' => tracks)
        path = "/me/library/playlists/#{playlist_id}/tracks"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.post(path, body, options)
      end

      def authenticated_tags
        return [] if @id
        path = "/me/library/playlists/#{playlist_id}/tags"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, options)
        return [] if response['tags']
        Tag.collection(data: response['tags'], client: @client)
      end

      def recommended_tracks(playlist_id)
        options = {
          params: { playlistId: playlist_id },
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/recommendations/tracks', options)
        Track.collection(data: response['tracks'], client: @client)
      end

      def uploaded_images(options)
        return uploaded_images_with_size(options) if options.class == Fixnum
        e = 'Playlist ID is missing.'
        playlist_id = options[:id] ? options[:id] : @id
        raise ArgumentError, e unless playlist_id

        path = "/me/library/playlists/#{playlist_id}/images"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        options[:params] = { size: options[:size] } if options[:size]
        response = @client.get(path, options)
        UploadedImage.collection(data: response['images'], client: @client)
      end

      private

      def uploaded_images_with_size(size)
        path = "/me/library/playlists/#{@id}/images"
        options = {
          params: { size: size },
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, options)
        UploadedImage.collection(data: response['images'], client: @client)
      end
    end
  end
end
