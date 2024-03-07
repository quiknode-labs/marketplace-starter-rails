# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Provisionings", type: :request do
  let(:credentials) {
    ActionController::HttpAuthentication::Basic.encode_credentials(
      Rails.application.credentials.basic_auth.name,
      Rails.application.credentials.basic_auth.password,
    )
  }
  describe "POST /provision" do
    it "should require HTTP Basic Auth" do
      post "/provision"
      expect(response).to have_http_status(401)
    end

    it "should create an account and an endpoint" do
      expect {
        expect {
          post "/provision", params: {
            "quicknode-id": "9469f6bfc411b1c23f0f3677bcd22b890a4a755273dc2c0ad38559f7e1eb2700",
            "endpoint-id": "2c03e048-5778-4944-b804-0de77df9363a",
            "wss-url": "wss://long-late-firefly.quiknode.pro/2f568e4df78544629ce9af64bbe3cef9145895f5/",
            "http-url": "https://long-late-firefly.quiknode.pro/2f568e4df78544629ce9af64bbe3cef9145895f5/",
            "referers": ["quicknode.com"],
            "contract_addresses": [],
            "chain": "ethereum",
            "network": "mainnet",
            "plan": "your-plan-slug",
          }, headers: { "Authorization" => credentials }
        }.to change { Endpoint.kept.count }.by(1)
      }.to change { Account.kept.count }.by(1)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)['status']).to eq("success")
      expect(assigns(:account).is_test?).to eq(false)
    end

    it "should create a test account if the X-QN-TESTING header is present" do
      post "/provision", params: {
          "quicknode-id": "9469f6bfc411b1c23f0f3677bcd22b890a4a755273dc2c0ad38559f7e1eb2700",
          "endpoint-id": "2c03e048-5778-4944-b804-0de77df9363a",
          "wss-url": "wss://long-late-firefly.quiknode.pro/2f568e4df78544629ce9af64bbe3cef9145895f5/",
          "http-url": "https://long-late-firefly.quiknode.pro/2f568e4df78544629ce9af64bbe3cef9145895f5/",
          "referers": ["quicknode.com"],
          "contract_addresses": [],
          "chain": "ethereum",
          "network": "mainnet",
          "plan": "your-plan-slug",
        }, headers: { "Authorization" => credentials, 'X-QN-TESTING': true }
        expect(response).to have_http_status(200)
        expect(assigns(:account).is_test?).to eq(true)
    end

    it "should 200 AND not create an account if it already exists" do
      account = create(:account)
      expect {
        expect {
          post "/provision", params: {
            "quicknode-id": account.quicknode_id,
            "endpoint-id": "2c03e048-5778-4944-b804-0de77df9363a",
            "wss-url": "wss://long-late-firefly.quiknode.pro/2f568e4df78544629ce9af64bbe3cef9145895f5/",
            "http-url": "https://long-late-firefly.quiknode.pro/2f568e4df78544629ce9af64bbe3cef9145895f5/",
            "referers": ["quicknode.com"],
            "contract_addresses": [],
            "chain": "ethereum",
            "network": "mainnet",
            "plan": "your-plan-slug",
          }, headers: { "Authorization" => credentials }
        }.to change { Endpoint.kept.count }.by(1)
      }.to change{ Account.kept.count }.by(0)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)['status']).to eq("success")
      expect(assigns(:account).is_test?).to eq(false)
      expect(assigns(:endpoint).account).to eq(account)
    end
  end

  describe "PUT /update" do
    let(:account) { create(:account) }
    let(:endpoint) { create(:endpoint, account: account) }

    it "should require HTTP Basic Auth" do
      put "/update"
      expect(response).to have_http_status(401)
    end

    it "should 404 if the account does not exist" do
      put "/update", params: { "quicknode-id": "does-not-exist" }, headers: { "Authorization" => credentials }
      expect(response).to have_http_status(404)
    end

    it "should 404 if the endpoint does not exist" do
      put "/update", params: {
        "quicknode-id": account.quicknode_id,
        "endpoint-id": "does-not-exist",
      }, headers: { "Authorization" => credentials }
      expect(response).to have_http_status(404)
    end

    it "should update an account plan" do
      new_http_url = Faker::Internet.url
      new_wss_url = Faker::Internet.url
      put "/update", params: {
        "quicknode-id": account.quicknode_id,
        "endpoint-id": endpoint.quicknode_id,
        "http-url": new_http_url,
        "wss-url": new_wss_url,
        plan: "moon",
      }, headers: { "Authorization" => credentials }
      expect(response).to have_http_status(200)

      expect(assigns(:account).plan_slug).to eq("moon")
      expect(assigns(:endpoint).http_url).to eq(new_http_url)
      expect(assigns(:endpoint).wss_url).to eq(new_wss_url)
    end
  end

  describe "DELETE /deactivate_endpoint" do
    let(:account) { create(:account) }

    it "should require HTTP Basic Auth" do
      delete "/deactivate_endpoint"
      expect(response).to have_http_status(401)
    end

    it "should 404 if the account does not exist" do
      delete "/deactivate_endpoint", params: { "quicknode-id": "does-not-exist" }, headers: { "Authorization" => credentials }
      expect(response).to have_http_status(404)
    end

    it "should 404 if the endpoint does not exist" do
      delete "/deactivate_endpoint", params: {
        "quicknode-id": account.quicknode_id,
        "endpoint-id": "does-not-exist",
      }, headers: { "Authorization" => credentials }
      expect(response).to have_http_status(404)
    end

    it "should discard the endpoint" do
      endpoint = create(:endpoint, account: account)
      expect {
        expect {
          delete "/deactivate_endpoint", params: {
            "quicknode-id": account.quicknode_id,
            "endpoint-id": endpoint.quicknode_id,
          }, headers: { "Authorization" => credentials }
        }.to change { Endpoint.kept.count }.by(-1)
      }.to change { Account.kept.count }.by(0)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['status']).to eq("success")
    end
  end

  describe "DELETE /deprovision" do
    let(:account) { create(:account) }

    it "should require HTTP Basic Auth" do
      delete "/deprovision"
      expect(response).to have_http_status(401)
    end

    it "should 404 if the account does not exist" do
      delete "/deprovision", params: { "quicknode-id": "does-not-exist" }, headers: { "Authorization" => credentials }
      expect(response).to have_http_status(404)
    end

    it "should discard the account and all its endpoints" do
      endpoint = create(:endpoint, account: account)
      create(:endpoint, account: account)
      create(:endpoint, account: account)

      expect(account.endpoints.kept.count).to eq 3

      expect {
        expect {
          delete "/deprovision", params: {
            "quicknode-id": account.quicknode_id,
            "endpoint-id": endpoint.quicknode_id,
          }, headers: { "Authorization" => credentials }
        }.to change { Endpoint.kept.count }.by(-3)
      }.to change { Account.kept.count }.by(-1)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['status']).to eq("success")
    end
  end
end
