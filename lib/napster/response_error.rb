module Napster
  # Raised when the response status is anything over 400
  class ResponseError < Faraday::Error
    attr_accessor :http_status,
                  :response_body,
                  :faraday_response

    # Initialize a Faraday client
    # @param response [Faraday::Response] Should contain error response.
    # @return [ResponseError] Return error object with info about the error.
    def initialize(response)
      @http_status = response.status
      @response_body = response.body
      @faraday_response = response
    end
  end
end
