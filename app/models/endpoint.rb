# frozen_string_literal: true

class Endpoint < ApplicationRecord
  include Discard::Model

  belongs_to :account

  validates :account_id, presence: true
  validates :quicknode_id, presence: true
  validates :chain, presence: true
  validates :network, presence: true
  validates :http_url, presence: true
end
