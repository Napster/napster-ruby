module Napster
  module Models
    # Station model
    class Station
      ATTRIBUTES = [:type,
                    :id,
                    :href,
                    :sub_type,
                    :name,
                    :author,
                    :description,
                    :summary,
                    :artists,
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
        arg[:data].map do |tag|
          Station.new(data: tag, client: @client)
        end
      end

      # Top level methods

      def top
        response = @client.get('/stations/top')
        Station.collection(data: response['stations'])
      end

      def decade
        response = @client.get('/stations/decade')
        Station.collection(data: response['stations'])
      end

      def find(id)
        e = 'Invalid playlist id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :station)
        response = @client.get("/stations/#{id}")
        Station.new(data: response['stations'].first, client: @client)
      end
    end
  end
end
