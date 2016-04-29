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
          Tag.new(data: tag, client: @client)
        end
      end

      # Top level methods

      def all
        response = @client.get('/tags')
        Tag.collection(data: response['tags'])
      end

      def featured
        response = @client.get('/tags/featured')
        Tag.collection(data: response['tags'])
      end

      def find(id)
        e = 'Invalid tag id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :tag)
        response = @client.get("/tags/#{id}")
        Tag.new(data: response['tags'].first, client: @client)
      end
    end
  end
end
