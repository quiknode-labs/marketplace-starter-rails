# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  discarded_at :datetime
#  is_test      :boolean          default(FALSE), not null
#  plan_slug    :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  quicknode_id :string           not null
#
# Indexes
#
#  index_accounts_on_discarded_at  (discarded_at)
#  index_accounts_on_quicknode_id  (quicknode_id)
#
class Account < ApplicationRecord
  include Discard::Model

  has_many :endpoints, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :quicknode_id, presence: true
  validates :plan_slug, presence: true
end
