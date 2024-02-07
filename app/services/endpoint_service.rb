# frozen_string_literal: true

class EndpointService
  def initialize(endpoint)
    @endpoint = endpoint
  end

  def rpc_call(method, params)
    response = HTTParty.post(
      @endpoint.http_url,
      headers: { 'Content-Type': 'application/json' },
      body: {
        method:,
        id: SecureRandom.uuid,
        jsonrpc: '2.0',
        params:,
      }.to_json,
    )

    JSON.parse(response.body)
  end
end
