# frozen_string_literal: true

module RPCMethodHandlers
  class EthSendRawTransactionFaster
    def initialize(params)
      @params = params
    end

    def call
      {
        jsonrpc: "2.0",
        result: "transaction was sent successfully and faster",
      }
    end
  end
end
