# frozen_string_literal: true

class Account < ApplicationRecord
  validates :quicknode_id, presence: true
  validates :plan_slug, presence: true
end
