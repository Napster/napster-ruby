module Napster
  module Models
    # Radio model
    class Radio
      ATTRIBUTES = [:type,
                    :id,
                    :href,
                    :band,
                    :name,
                    :city,
                    :country,
                    :description,
                    :dial,
                    :encoding,
                    :image_url,
                    :lang_code,
                    :language,
                    :latitude,
                    :longitude,
                    :slogan,
                    :state,
                    :url].freeze

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
        arg[:data].map do |radio|
          Radio.new(data: radio, client: @client)
        end
      end

      # Top level methods

      def find(id)
        e = 'Invalid playlist id'
        raise ArgumentError, e unless Napster::Moniker.check(id, :radio)
        response = @client.get("/radios/#{id}")
        Radio.new(data: response['radios'].first, client: @client)
      end

      def featured
        response = @client.get('/radios/featured')
        Radio.collection(data: response['radios'])
      end
    end
  end
end
