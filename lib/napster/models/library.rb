module Napster
  module Models
    # Library model
    class Library
      attr_accessor :client

      def initialize(arg)
        @client = arg[:client] if arg[:client]
        return unless arg[:data]
      end

      def artists(params)
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/library/artists', get_options)
        Artist.collection(data: response['artists'], client: @client)
      end

      def artist_albums(artist_id, params)
        path = "/me/library/artists/#{artist_id}/albums"
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, get_options)
        Album.collection(data: response['albums'], client: @client)
      end

      def artist_tracks(artist_id, params)
        path = "/me/library/artists/#{artist_id}/tracks"
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, get_options)
        Track.collection(data: response['tracks'], client: @client)
      end

      def albums(params)
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/library/albums', get_options)
        Album.collection(data: response['albums'], client: @client)
      end

      def album_tracks(album_id, params)
        path = "/me/library/albums/#{album_id}/tracks"
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, get_options)
        Track.collection(data: response['tracks'], client: @client)
      end

      def tracks(params)
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/library/tracks', get_options)
        Track.collection(data: response['tracks'], client: @client)
      end

      def add_track(tracks)
        e = 'tracks argument should be an array.'
        raise ArgumentError, e unless tracks.class == Array

        tracks = tracks.join(',')
        options = {
          params: { id: tracks },
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.post('/me/library/tracks', '{}', options)
      end

      def remove_track(track_id)
        path = "/me/library/tracks/#{track_id}"
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        @client.delete(path, options)
      end

      def last_updated_date
        path = '/me/library/updated'
        options = {
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get(path, options)
        LibraryDateTime.new(data: response['lastUpdateDate'], client: @client)
      end
    end
  end
end
