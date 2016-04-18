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
                    :albumGroups,
                    :links].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s])
        end
      end

      def self.collection(artists)
        artists.map do |artist|
          Artist.new(artist)
        end
      end
    end
  end
end
