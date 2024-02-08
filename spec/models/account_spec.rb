# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { create(:account) }

  it "is valid with valid attributes" do
    a = create(:account)
    expect(a).to be_valid
  end

  describe "Associations" do
    it { should have_many(:endpoints) }
    it { should have_many(:users) }
  end

  describe "Validations" do
    it { should validate_presence_of(:quicknode_id) }
    it { should validate_presence_of(:plan_slug) }
  end

  it "discard should set discarded_at" do
    expect(account.discarded_at).to eq nil
    account.discard
    expect(account.discarded?).to eq true
    expect(account.kept?).to eq false
    expect(account.discarded_at).to_not eq nil
  end
end
