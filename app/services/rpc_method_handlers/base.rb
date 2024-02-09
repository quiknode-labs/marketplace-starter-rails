# frozen_string_literal: true

module RPCMethodHandlers
  class Base
    attr_reader :endpoint, :endpoint_service

    def initialize(params, endpoint)
      @params = params
      @endpoint = endpoint
      @endpoint_service = EndpointService.new(endpoint)
    end
  end
end
