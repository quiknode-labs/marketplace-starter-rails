require 'rails_helper'

RSpec.describe "RPC", type: :request do
  describe "POST /rpc" do
    it "should 400 if missing X-QUICKNODE-ID header"
    it "should 400 if missing X-INSTANCE-ID header"
    it "should 400 if missing X-QN-CHAIN header"
    it "should 400 if missing X-QN-NETWORK header"
    it "should 404 if account was not provisioned"
    it "should 404 if the method is not supported"

    it "should 200 if the method is supported"
  end
end
