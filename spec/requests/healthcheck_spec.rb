require 'rails_helper'

RSpec.describe "Healthchecks", type: :request do
  describe "GET /index" do
    it "should return OK with status 200" do
      get rails_health_check_path
      expect(response).to have_http_status(200)
      expect(response.body).to eq("<!DOCTYPE html><html><body style=\"background-color: green\"></body></html>")
    end
  end
end
