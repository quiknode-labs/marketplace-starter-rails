# frozen_string_literal: true

module RPCMethodHandlers
  class QnHelloWorld
    def initialize(params)
      @params = params
    end

    def call
      {
        jsonrpc: "2.0",
        result: "hello world",
        params: @params,
      }
    end
  end
end
