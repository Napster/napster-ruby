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

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s.camel_case_lower])
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
