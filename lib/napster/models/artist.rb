module Napster
  module Models
    # Artist model
    class Artist
      RESPONSE_ATTRIBUTES = [:type,
                             :id,
                             :href,
                             :name,
                             :shortcut,
                             :blurbs,
                             :bios,
                             :album_groups,
                             :links].freeze

      RESPONSE_ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      attr_accessor :client

      def initialize(arg)
        @client = arg[:client]
        RESPONSE_ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[:data][attribute.to_s.camel_case_lower])
        end
      end

      def self.collection(arg)
        arg[:data].map do |artist|
          Artist.new({ data: artist, client: arg[:client] })
        end
      end

      # Instance methods

      def albums
        response = @client.get("/artists/#{@id}/albums")
        Napster::Models::Album.collection(response['albums'])
      end

      def top_albums
        response = @client.get("/artists/#{@id}/albums/top")
        Napster::Models::Album.collection(response['albums'])
      end

      def new_albums
        response = @client.get("/artists/#{@id}/albums/new")
        Napster::Models::Album.collection(response['albums'])
      end

      def tracks
        response = @client.get("/artists/#{@id}/tracks")
        Napster::Models::Track.collection(response['tracks'])
      end

      def top_tracks
        response = @client.get("/artists/#{@data.id}/tracks/top")
        Napster::Models::Track.collection(response['tracks'])
      end
    end
  end
end
