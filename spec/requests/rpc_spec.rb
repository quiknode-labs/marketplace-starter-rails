require 'rails_helper'

RSpec.describe "RPC", type: :request do
  describe "POST /rpc" do
    let (:account) { create(:account) }
    let (:discarded_account) { create(:account, discarded_at: 2.months.ago) }

    it "should 400 if missing X-QUICKNODE-ID header" do
      post "/rpc", headers: {
        'X-INSTANCE-ID': 'foobar',
        'X-QN-CHAIN': 'ethereum',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(400)
    end

    it "should 400 if missing X-INSTANCE-ID header" do
      post "/rpc", headers: {
        'X-QUICKNODE-ID': 'quicknode-id',
        'X-QN-CHAIN': 'ethereum',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(400)
    end

    it "should 400 if missing X-QN-CHAIN header" do
      post "/rpc", headers: {
        'X-QUICKNODE-ID': 'quicknode-id',
        'X-INSTANCE-ID': 'foobar',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(400)
    end

    it "should 400 if missing X-QN-NETWORK header" do
      post "/rpc", headers: {
        'X-QUICKNODE-ID': 'quicknode-id',
        'X-INSTANCE-ID': 'foobar',
        'X-QN-CHAIN': 'ethereum',
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(400)
    end

    it "should 404 if account was not provisioned" do
      post "/rpc", headers: {
        'X-QUICKNODE-ID': 'quicknode-id',
        'X-INSTANCE-ID': 'foobar',
        'X-QN-CHAIN': 'ethereum',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(404)
    end

    it "should 404 if account was discarded" do
      post "/rpc", headers: {
        'X-QUICKNODE-ID': discarded_account.quicknode_id,
        'X-INSTANCE-ID': 'foobar',
        'X-QN-CHAIN': 'ethereum',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(404)
    end

    it "should 404 if the method is not present in params" do
      post "/rpc", params: {
        foobar: "bar",
      },
      headers: {
        'X-QUICKNODE-ID': account.quicknode_id,
        'X-INSTANCE-ID': 'foobar',
        'X-QN-CHAIN': 'ethereum',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(404)
    end

    it "should 404 if the method is not supported" do
      post "/rpc", params: {
        method: "unsupported_method",
      },
      headers: {
        'X-QUICKNODE-ID': account.quicknode_id,
        'X-INSTANCE-ID': 'foobar',
        'X-QN-CHAIN': 'ethereum',
        'X-QN-NETWORK': 'mainet',
      }
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
      expect(JSON.parse(response.body)["error"]["code"]).to eq(404)
    end

    context("valid method and headers") do
      let (:endpoint) { create(:endpoint, account: account) }
      it "should 200 if the method is supported: qn_helloWorld" do
        post "/rpc", params: {
          method: "qn_helloWorld",
          params: ['abc'],
        },
        headers: {
          'X-QUICKNODE-ID': account.quicknode_id,
          'X-INSTANCE-ID': endpoint.quicknode_id,
          'X-QN-CHAIN': 'ethereum',
          'X-QN-NETWORK': 'mainet',
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
        expect(JSON.parse(response.body)["result"]).to eq("hello world")
        expect(JSON.parse(response.body)["params"]).to eq(['abc'])
        expect(assigns(:account)).to eq(account)
        expect(assigns(:endpoint)).to eq(endpoint)
      end

      it "should 200 if the method is supported: eth_sendRawTransactionFaster" do
        post "/rpc", params: {
          method: "eth_sendRawTransactionFaster",
        },
        headers: {
          'X-QUICKNODE-ID': account.quicknode_id,
          'X-INSTANCE-ID': endpoint.quicknode_id,
          'X-QN-CHAIN': 'ethereum',
          'X-QN-NETWORK': 'mainet',
        }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["jsonrpc"]).to eq("2.0")
        expect(JSON.parse(response.body)["result"]).to eq("transaction was sent successfully and faster")
        expect(assigns(:account)).to eq(account)
        expect(assigns(:endpoint)).to eq(endpoint)
      end
    end
  end
end
