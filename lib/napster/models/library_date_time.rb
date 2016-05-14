module Napster
  module Models
    # LibraryDateTime model
    # Only used for /me/library/updated
    class LibraryDateTime
      ATTRIBUTES = [:date,
                    :time_zone,
                    :time_in_millis].freeze

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
        arg[:data].map do |library_date_time|
          LibraryDateTime.new(data: library_date_time, client: @client)
        end
      end
    end
  end
end
