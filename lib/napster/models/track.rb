module Napster
  module Models
    # Track model
    class Track
      ATTRIBUTES = [:type,
                    :id,
                    :index,
                    :disc,
                    :href,
                    :playbackSeconds,
                    :explicit,
                    :name,
                    :isrc,
                    :shortcut,
                    :amg,
                    :blurbs,
                    :artistName,
                    :albumName,
                    :formats,
                    :albumId,
                    :contributors].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s])
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
