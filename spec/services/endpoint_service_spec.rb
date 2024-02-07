# frozen_string_literal: true

require "rails_helper"

RSpec.describe EndpointService do
  let(:endpoint) { create(:endpoint, http_url: 'https://docs-demo.quiknode.pro/') }
  let(:service) { EndpointService.new(endpoint) }

  it "should make RPC call and return response" do
    response = service.rpc_call('web3_clientVersion', [])
    expect(response['jsonrpc']).to eq('2.0')
    expect(response['result']).to include('Geth')
  end
end