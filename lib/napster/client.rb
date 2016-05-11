module Napster
  # The Client class implements a client object that prepares
  # information such as api_key, api_secret, and :redirect_uri
  # needed to call Napster API.
  class Client
    MODELS_LIST = %w(artist album track genre member playlist tag
                     station radio favorite).freeze
    AUTH_METHODS = [:password_grant, :oauth2].freeze

    attr_accessor :api_key,
                  :api_secret,
                  :redirect_uri,
                  :username,
                  :password,
                  :state,
                  :auth_code,
                  :access_token,
                  :refresh_token,
                  :expires_in,
                  :request

    # Instantiate a client object
    # @note request attribute is always overwritten by Napster::Request
    #   object.
    # @param options [Hash] Required options are :api_key and :api_secret
    def initialize(options)
      options.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      request_hash = {
        api_key: @api_key,
        api_secret: @api_secret
      }
      @request = Napster::Request.new(request_hash)
      authenticate_client
      set_models
    end

    # Make a post request to Napster API
    # @param path [String] API path
    # @param body [Hash] Body for the post request
    # @param options [Hash] Faraday adapter options
    # @return [Hash] parsed response from Napster API
    def post(path, body = {}, options = {})
      validate_request(path, options)
      raw_response = @request.faraday.post do |req|
        req.url path, options[:params]
        req.body = body
        req.headers['apikey'] = @api_key
        if options[:headers]
          options[:headers].each do |key, value|
            req.headers[key] = value
          end
        end
      end
      Oj.load(raw_response.body)
    end

    # Make a get request to Napster API
    # @param path [String] API path
    # @param options [Hash] Faraday adapter options accepting
    #   headers
    # @return [Hash] parsed response from Napster API
    def get(path, options = {})
      validate_request(path, options)
      raw_response = @request.faraday.get do |req|
        req.url path, options[:params]
        req.headers['apikey'] = @api_key
        if options[:headers]
          options[:headers].each do |key, value|
            req.headers[key] = value
          end
        end
      end
      Oj.load(raw_response.body)
    end

    # Make a put request to Napster API
    # @param path [String] API path
    # @param body [Hash] Body for the put request
    # @param options [Hash] Faraday apapter options accepting
    #   headers, params
    # @return [Hash] parsed response from Napster API
    def put(path, body = {}, options = {})
      validate_request(path, options)
      raw_response = @request.faraday.put do |req|
        req.url path, options[:params]
        req.body = body
        req.headers['apikey'] = @api_key
        if options[:headers]
          options[:headers].each do |key, value|
            req.headers[key] = value
          end
        end
      end
      Oj.load(raw_response.body)
    end

    # Make a delete request to Napster API
    # @param path [String] API path
    # @param options [Hash] Faraday apapter options accepting
    #   headers, params
    # @return [Hash] parsed response from Napster API
    def delete(path, options = {})
      validate_request(path, options)
      raw_response = @request.faraday.put do |req|
        req.url path, options[:params]
        req.headers['apikey'] = @api_key
        if options[:headers]
          options[:headers].each do |key, value|
            req.headers[key] = value
          end
        end
      end
      Oj.load(raw_response.body)
    end

    # Smarter method for authentication via password_grant or oauth2
    # @return [Client]
    def connect
      return authenticate(:password_grant) if authenticate_via_password_grant?
      return authenticate(:oauth2) if authenticate_via_oauth2?
      raise ArgumentError
    end

    # Main method for authenticating against Napster API
    # @param auth_method [Symbol] authentication methods that are
    #   :password_grant or :oauth2
    # @return [Hash] response from Napster API
    def authenticate(auth_method)
      validate_authenticate(auth_method)

      return auth_password_grant if auth_method == :password_grant
      return auth_oauth2 if auth_method == :oauth2
    end

    # Get URL for OAuth2 authentication flow
    # @return [String] OAuth2 authentication URL
    def authentication_url
      validate_authentication_url
      query_params = {
        client_id: @api_key,
        redirect_uri: @redirect_uri,
        response_type: 'code'
      }
      query_params[:state] = @state if @state
      query_params_string = URI.encode_www_form(query_params)
      Napster::Request::HOST_URL + '/oauth/authorize?' + query_params_string
    end

    # Include Me module for calling authenticated methods
    def me
      Napster::Me.new(self)
    end

    private

    # Helper method for .new, choose authentication method, and authenticate
    # @return [Client] Authenticated client
    def authenticate_client
      return authenticate(:password_grant) if authenticate_via_password_grant?
      self
    end

    # Helper method for #authenticate_client, check if password_grant auth is
    #   possible with current attributes.
    # @return [Boolean]
    def authenticate_via_password_grant?
      @api_key && @api_secret && @username && @password
    end

    def authenticate_via_oauth2?
      @api_key && @api_secret && @redirect_uri && @auth_code
    end

    def validate_request(path, options)
      raise ArgumentError, 'path is missing' unless path
      raise ArgumentError, 'options should be a hash' unless options.is_a?(Hash)
      if options[:headers] && !options[:headers].is_a?(Hash)
        raise ArgumentError, 'options[:headers] should be a hash'
      end
    end

    def validate_authenticate(auth_method)
      unless auth_method.is_a?(Symbol)
        err = 'Authentication method must be passed as a symbol'
        raise ArgumentError, err
      end

      unless AUTH_METHODS.include?(auth_method)
        err = "Wrong authentication method. Valid methods are #{AUTH_METHODS}"
        raise ArgumentError, err
      end
    end

    def auth_password_grant
      validate_auth_password_grant
      body = post('/oauth/token',
                  auth_password_grant_post_body,
                  auth_password_grant_post_options)
      @access_token = body['access_token']
      @refresh_token = body['refresh_token']
      @expires_in = body['expires_in']

      self
    end

    def auth_password_grant_post_body
      {
        response_type: 'code',
        grant_type: 'password',
        username: @username,
        password: @password
      }
    end

    def auth_password_grant_post_options
      basic_auth = Faraday::Request::BasicAuthentication.header(@api_key,
                                                                @api_secret)
      { headers: { Authorization: basic_auth } }
    end

    def validate_auth_password_grant
      raise 'The client is missing username' unless @username
      raise 'The client is missing password' unless @password
    end

    def auth_oauth2
      validate_auth_oauth2
      response_body = post('/oauth/access_token', auth_oauth2_post_body, {})
      @access_token = response_body['access_token']
      @refresh_token = response_body['refresh_token']
      @expires_in = response_body['expires_in']
      self
    end

    def auth_oauth2_post_body
      {
        client_id: @api_key,
        client_secret: @api_secret,
        response_type: 'code',
        grant_type: 'authorization_code',
        code: @auth_code,
        redirect_uri: @redirect_uri
      }
    end

    def validate_auth_oauth2
      raise 'The client is missing redirect_uri' unless @redirect_uri
      raise 'The client is missing auth_code' unless @auth_code
    end

    def validate_authentication_url
      raise 'The client is missing redirect_uri' unless @redirect_uri
    end

    # Helper method for Client.new
    #   Set resources methods on the client
    # @return [Client]
    def set_resources
      RESOURCES_LIST.each do |resource|
        define_singleton_method(resource) do
          Object.const_get(resource_class_name(resource)).new(self)
        end
      end
      self
    end

    def resource_class_name(resource)
      # "Napster::Resources::Metadata::#{resource.capitalize}Resource"
    end

    def set_models
      MODELS_LIST.each do |model|
        define_singleton_method("#{model}s") do
          Object.const_get(model_class_name(model)).new(client: self)
        end
      end
      self
    end

    def model_class_name(model)
      "Napster::Models::#{model.capitalize}"
    end
  end
end
