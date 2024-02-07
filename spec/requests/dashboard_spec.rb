require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:account) { create(:account) }

  describe "GET /dashboard/:quicknode_id" do
    it "should 400 if missing jwt token in params"

    it "should 503 if the jwt token is invalid"

    it "should 503 if the jwt token is expired"

    it "should 503 if the jwt token is not allowed"

    it "should 503 if the jwt token is not supported"

    it "should 503 if the jwt token is not well formed"

    it "should 404 if the account is not provisioned"

    describe "valid JWT token" do
      it "returns http success" do
        get "/dashboard/#{account.quicknode_id}"
        expect(response).to have_http_status(:success)
      end

      it "should render dashboard"
    end
  end

end
