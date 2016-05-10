module Napster
  module Models
    # Album model
    class Album
      ATTRIBUTES = [:type,
                    :id,
                    :upc,
                    :shortcut,
                    :href,
                    :name,
                    :released,
                    :originally_released,
                    :label,
                    :copyright,
                    :tags,
                    :disc_count,
                    :track_count,
                    :explicit,
                    :single,
                    :account_partner,
                    :artist_name,
                    :contributing_artists].freeze

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
        arg[:data].map do |album|
          Album.new(data: album, client: @client)
        end
      end

      # Top level methods

      def new_releases
        response = @client.get('/albums/new')
        Album.collection(data: response['albums'])
      end

      def staff_picks
        response = @client.get('/albums/picks')
        Album.collection(data: response['albums'])
      end

      def top
        response = @client.get('/albums/top')
        Album.collection(data: response['albums'])
      end

      def find(arg)
        return find_by_id(arg) if Napster::Moniker.check(arg, :album)
        find_by_name(arg)
      end

      def find_by_id(id)
        response = @client.get("/albums/#{id}")
        Album.new(data: response['albums'].first, client: @client)
      end

      def find_all_by_name(name)
        options = {
          params: {
            q: name,
            type: 'album'
          }
        }
        response = @client.get('/search', options)
        Album.collection(data: response['data'])
      end

      def find_by_name(name)
        find_all_by_name(name).first
      end

      # Instance methods

      def tracks
        response = @client.get("/albums/#{@id}/tracks")
        Track.collection(data: response['tracks'])
      end
    end
  end
end
