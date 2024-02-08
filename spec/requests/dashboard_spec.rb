require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:account) { create(:account) }
  let(:invalid_jwt_payload) {
    {
      quicknode_id: "bad-quicknode-id",
      email: "hello@example.com",
      name: "John Smith",
      organization_name: "Example",
    }
  }
  let(:valid_jwt_payload) {
    {
      quicknode_id: account.quicknode_id,
      email: "hello@example.com",
      name: "John Smith",
      organization_name: "Example",
    }
  }
  let(:invalid_jwt_token) { JWT.encode(invalid_jwt_payload, Rails.application.credentials.jwt.secret, 'HS256') }
  let(:valid_jwt_token) { JWT.encode(valid_jwt_payload, Rails.application.credentials.jwt.secret, 'HS256') }

  describe "GET /dashboard/:quicknode_id" do
    it "should 401 if the jwt token is invalid" do
      get "/dashboard?jwt=invalid_token"
      expect(response).to have_http_status(401)
    end

    it "should 401 if the account is not provisioned" do
      get "/dashboard?jwt=#{invalid_jwt_token}"
      expect(response).to have_http_status(401)
    end

    describe "valid JWT token" do
      it "returns http success" do
        get "/dashboard?jwt=#{valid_jwt_token}"
        expect(response).to have_http_status(:success)
      end

      it "should render dashboard" do
        get "/dashboard?jwt=#{valid_jwt_token}"
        expect(response.body).to include("Dashboard")
        expect(response.body).to include("John Smith")
        expect(response.body).to include("hello@example.com")
        expect(response.body).to include("Example")
      end
    end
  end

end
