using StringHelper

module Napster
  module Models
    # UploadedImage model
    class UploadedImage
      ATTRIBUTES = [:content_id,
                    :image_type,
                    :url,
                    :default_image,
                    :image_id,
                    :version].freeze

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
        arg[:data].map do |uploaded_image|
          UploadedImage.new(data: uploaded_image, client: @client)
        end
      end
    end
  end
end
