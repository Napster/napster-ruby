module Napster
  module Models
    # Chart model
    class Chart
      ATTRIBUTES = [:id,
                    :play_count,
                    :type,
                    :links].freeze

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
        arg[:data].map do |chart|
          Chart.new(data: chart, client: @client)
        end
      end
    end
  end
end
