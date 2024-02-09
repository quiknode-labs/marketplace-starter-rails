# frozen_string_literal: true

module RPCMethodHandlers
  class EthSendRawTransactionFaster < RPCMethodHandlers::Base
    def call
      # To implement a new RPC method, copy this file and make sure it returns a ruby hash that can be converted to JSON
      # Inside this file, you can make JSON-RPC calls to the blockchain node/endpoint using:
      #     endpoint_service.rpc_call(method, params)
      {
        jsonrpc: "2.0",
        result: "transaction was sent successfully and faster",
      }
    end
  end
end
