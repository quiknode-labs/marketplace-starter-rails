# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoint, type: :model do
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
end
