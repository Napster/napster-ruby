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

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s.camel_case_lower])
        end
      end

      def self.collection(tracks)
        tracks.map do |track|
          Track.new(track)
        end
      end
    end
  end
end
