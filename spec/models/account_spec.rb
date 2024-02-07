# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "Associations" do
  end

  describe "Validations" do
    it { should validate_presence_of(:quicknode_id) }
    it { should validate_presence_of(:plan_slug) }
  end
end
