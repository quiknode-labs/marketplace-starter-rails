# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Provisionings", type: :request do
  describe "POST /provision" do
    it "should require HTTP Basic Auth"

    it "should create an account and an endpoint"

    it "should not create an account if it already exists" do
    end
  end

  describe "PUT /update" do
    it "should require HTTP Basic Auth"

    it "should 404 if the account does not exist"

    it "should 404 if the endpoint does not exist"

    it "should update an account' plan"
  end

  describe "DELETE /deactivate_endpoint" do
    it "should require HTTP Basic Auth"
    
    it "should 404 if the account does not exist"

    it "should 404 if the endpoint does not exist"

    it "should discard the endpoint"
  end

  describe "DELETE /deprovision" do
    it "should require HTTP Basic Auth"
    
    it "should 404 if the account does not exist"

    it "should discard the account and all its endpoints"
  end
end
