module Napster
  module Models
    # Genre model
    class Genre
      ATTRIBUTES = [:type,
                    :id,
                    :name,
                    :href,
                    :shortcut,
                    :description].freeze

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
        arg[:data].map do |genre|
          Genre.new(data: genre, client: @client)
        end
      end

      # Top level methods

      def all
        response = @client.get('/genres')
        Genre.collection(data: response['genres'])
      end

      def find(arg)
        e_msg = 'Invalid genre id'
        raise ArgumentError, e_msg unless Napster::Moniker.check(arg, :genre)
        find_by_id(arg)
      end

      def find_by_id(id)
        response = @client.get("/genres/#{id}")
        Genre.new(data: response['genres'].first, client: @client)
      end

      # Instance methods

      def top_artists
        response = @client.get("/genres/#{@id}/artists/top")
        Artist.collection(data: response['artists'])
      end

      def top_albums
        response = @client.get("/genres/#{@id}/albums/top")
        Album.collection(data: response['albums'])
      end

      def top_tracks
        response = @client.get("/genres/#{@id}/tracks/top")
        Track.collection(data: response['tracks'])
      end

      def new_releases
        response = @client.get("/genres/#{@id}/albums/new")
        Album.collection(data: response['albums'])
      end

      def top_listeners(params)
        options = {
          params: params
        }
        response = @client.get("/genres/#{@id}/listeners/top", options)
        Member.collection(data: response['listeners'])
      end
    end
  end
end
