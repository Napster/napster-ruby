module Napster
  class ResponseError < Faraday::Response::RaiseError
    def message
      "HTTP status: #{response.code}"
    end
  end
end
