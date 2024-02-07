# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  let(:endpoint) { create(:endpoint) }

  it "is valid with valid attributes" do
    e = create(:endpoint)
    expect(e).to be_valid
  end

  describe "Associations" do
    it { should belong_to(:account) }
  end

  describe "Validations" do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:quicknode_id) }
    it { should validate_presence_of(:chain) }
    it { should validate_presence_of(:network) }
    it { should validate_presence_of(:http_url) }
  end

  it "discard should set discarded_at" do
    expect(endpoint.discarded_at).to eq nil
    endpoint.discard
    expect(endpoint.discarded?).to eq true
    expect(endpoint.kept?).to eq false
    expect(endpoint.discarded_at).to_not eq nil
  end
end
