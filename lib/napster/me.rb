module Napster
  # Authenticated endpoints under /me namespace
  class Me
    MODELS_LIST = %w(favorite playlist).freeze
    attr_accessor :client

    def initialize(client)
      validate_access_token(client)
      @client = client
      set_models
    end

    def listening_history(params)
      get_options = {
        params: params,
        headers: {
          Authorization: 'Bearer ' + @client.access_token,
          'Content-Type' => 'application/json',
          'Accept-Version' => '2.0.0'
        }
      }
      response = @client.get('/me/listens', get_options)
      Napster::Models::Track
        .collection(data: response['tracks'], client: @client)
    end

    def library
      Napster::Models::Library.new(client: @client)
    end

    def profile
      Napster::Models::Profile.new(client: @client)
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
