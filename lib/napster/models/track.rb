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
        arg[:data].map do |track|
          Track.new(data: track, client: @client)
        end
      end
    end
  end
end
