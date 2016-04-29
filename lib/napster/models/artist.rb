module Napster
  module Models
    # Artist model
    class Artist
      ATTRIBUTES = [:type,
                    :id,
                    :href,
                    :name,
                    :shortcut,
                    :blurbs,
                    :bios,
                    :album_groups,
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
        arg[:data].map do |artist|
          Artist.new(data: artist, client: arg[:client])
        end
      end

      # Top level methods

      def top
        response = @client.get('/artists/top')
        Artist.collection(data: response['artists'])
      end

      def find(arg)
        return find_by_id(arg) if Napster::Moniker.check(arg, :artist)
        find_by_name(arg)
      end

      def find_by_id(id)
        response = @client.get("/artists/#{id}")
        Artist.new(data: response['artists'].first, client: @client)
      end

      def find_all_by_name(name)
        options = {
          params: {
            q: name,
            type: 'artist'
          }
        }
        response = @client.get('/search', options)
        Artist.collection(data: response['data'], client: @client)
      end

      def find_by_name(name)
        find_all_by_name(name).first
      end

      # Instance methods

      def albums
        response = @client.get("/artists/#{@id}/albums")
        Album.collection(data: response['albums'])
      end

      def top_albums
        response = @client.get("/artists/#{@id}/albums/top")
        Album.collection(data: response['albums'])
      end

      def new_albums
        response = @client.get("/artists/#{@id}/albums/new")
        Album.collection(data: response['albums'])
      end

      # TODO: add limits
      def tracks
        options = {
          params: {
            limit: 10
          }
        }
        response = @client.get("/artists/#{@id}/tracks", options)
        Track.collection(data: response['tracks'])
      end

      def top_tracks
        response = @client.get("/artists/#{@data.id}/tracks/top")
        Track.collection(data: response['tracks'])
      end
    end
  end
end
