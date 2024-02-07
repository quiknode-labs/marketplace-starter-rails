# frozen_string_literal: true

class Account < ApplicationRecord
  include Discard::Model

  has_many :endpoints, dependent: :destroy

  validates :quicknode_id, presence: true
  validates :plan_slug, presence: true
end
