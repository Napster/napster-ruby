module Napster
  module Models
    # Tag model
    class Tag
      ATTRIBUTES = [:type,
                    :id,
                    :name,
                    :content_id,
                    :protected,
                    :shortcut,
                    :parent].freeze

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(arg)
        ATTRIBUTES.each do |attribute|
          send("#{attribute}=", arg[attribute.to_s.camel_case_lower])
        end
      end

      def self.collection(tags)
        tags.map do |tag|
          Tag.new(tag)
        end
      end
    end
  end
end
