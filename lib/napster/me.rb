module Napster
  class Me
    MODELS_LIST = %w(profile favorite).freeze
    attr_accessor :client

    def initialize(client)
      validate_access_token(client)
      @client = client
      set_models
    end

    private

    def validate_access_token(client)
      raise 'The client is missing access_token' unless client.access_token
    end

    def set_models
      MODELS_LIST.each do |model|
        define_singleton_method("#{model}s") do
          Object.const_get(model_class_name(model)).new(client: @client)
        end
      end
      self
    end

    def model_class_name(model)
      "Napster::Models::#{model.capitalize}"
    end
  end
end
