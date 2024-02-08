# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it "is valid with valid attributes" do
    e = create(:user)
    expect(e).to be_valid
  end

  describe "Associations" do
    it { should belong_to(:account) }
  end

  describe "Validations" do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:email) }
  end

  it "discard should set discarded_at" do
    expect(user.discarded_at).to eq nil
    user.discard
    expect(user.discarded?).to eq true
    expect(user.kept?).to eq false
    expect(user.discarded_at).to_not eq nil
  end
end
