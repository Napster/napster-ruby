module Napster
  module Models
    # Genre model
    class Genre
      ATTRIBUTES = [:type,
                    :id,
                    :name,
                    :href,
                    :shortcut,
                    :description].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s.camel_case_lower])
        end
      end

      def self.collection(genres)
        genres.map do |genre|
          Genre.new(genre)
        end
      end
    end
  end
end
