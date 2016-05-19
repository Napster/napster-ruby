using StringHelper

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

      def top(params)
        response = @client.get('/artists/top', params: params)
        Artist.collection(data: response['artists'], client: @client)
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

      def albums(params)
        response = @client.get("/artists/#{@id}/albums", params: params)
        Album.collection(data: response['albums'], client: @client)
      end

      def new_albums(params)
        response = @client.get("/artists/#{@id}/albums/new", params: params)
        Album.collection(data: response['albums'], client: @client)
      end

      def tracks(params)
        response = @client.get("/artists/#{@id}/tracks", params: params)
        Track.collection(data: response['tracks'], client: @client)
      end

      def top_tracks(params)
        response = @client.get("/artists/#{@id}/tracks/top", params: params)
        Track.collection(data: response['tracks'], client: @client)
      end
    end
  end
end
