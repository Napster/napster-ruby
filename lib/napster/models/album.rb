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
                    :originallyReleased,
                    :label,
                    :copyright,
                    :tags,
                    :discCount,
                    :trackCount,
                    :explicit,
                    :single,
                    :accountPartner,
                    :artistName,
                    :contributingArtists].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s])
        end
      end

      def self.collection(albums)
        albums.map do |album|
          Album.new(album)
        end
      end
    end
  end
end
