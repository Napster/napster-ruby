using StringHelper

module Napster
  module Models
    # Contet model
    # This model is used for
    class Content
      attr_accessor :client

      def self.collection(arg)
        arg[:data].map do |content|
          case content['type']
          when 'album'
            Album.new(data: content, client: @client)
          when 'artist'
            Artist.new(data: content, client: @client)
          when 'genre'
            Genre.new(data: content, client: @client)
          when 'playlist'
            Playlist.new(data: content, client: @client)
          when 'track'
            Track.new(data: content, client: @client)
          end
        end
      end
    end
  end
end
