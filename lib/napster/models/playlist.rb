module Napster
  module Models
    # Playlist model
    class Playlist
      ATTRIBUTES = [:type,
                    :id,
                    :name,
                    :modified,
                    :href,
                    :privacy,
                    :images,
                    :description,
                    :favorite_count,
                    :free_play_compliant].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s.camel_case_lower])
        end
      end

      def self.collection(playlists)
        playlists.map do |playlist|
          Playlist.new(playlist)
        end
      end
    end
  end
end
