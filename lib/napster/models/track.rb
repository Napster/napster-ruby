using StringHelper

module Napster
  module Models
    # Track model
    class Track
      ATTRIBUTES = [:type,
                    :id,
                    :index,
                    :disc,
                    :href,
                    :playback_seconds,
                    :explicit,
                    :name,
                    :isrc,
                    :shortcut,
                    :amg,
                    :blurbs,
                    :artist_name,
                    :album_name,
                    :formats,
                    :album_id,
                    :contributors].freeze

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
        return if !arg || !arg[:data]

        arg[:data].map do |track|
          Track.new(data: track, client: @client)
        end
      end

      def find(arg)
        return find_by_id(arg) if Napster::Moniker.check(arg, :track)
        find_by_name(arg)
      end

      def find_by_id(id)
        response = @client.get("/tracks/#{id}")
        Napster::Models::Track.new(data: response['tracks'].first)
      end

      def find_all_by_name(name)
        options = {
          params: {
            q: name,
            type: 'track'
          }
        }
        response = @client.get('/search', options)
        Napster::Models::Track.collection(data: response['data'])
      end

      def find_by_name(name)
        find_all_by_name(name).first
      end
    end
  end
end
