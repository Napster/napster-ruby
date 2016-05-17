module Napster
  module Models
    # Tag model
    class Tag
      SUPPORTED_CONTENT_TYPES = [:album,
                                 :artist,
                                 :genre,
                                 :playlist,
                                 :radio,
                                 :track].freeze
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

      def find(id)
        e = 'Invalid tag id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :tag)
        response = @client.get("/tags/#{id}")
        Tag.new(data: response['tags'].first, client: @client)
      end

      # /me

      def contents(named_tag, type, params)
        params[:tag] = named_tag if named_tag
        params[:type] = type.to_s if type
        get_options = {
          params: params,
          headers: {
            Authorization: 'Bearer ' + @client.access_token,
            'Content-Type' => 'application/json',
            'Accept-Version' => '2.0.0'
          }
        }
        response = @client.get('/me/tags/search', get_options)
        Content.collection(data: response['data'], client: @client)
      end
    end
  end
end
