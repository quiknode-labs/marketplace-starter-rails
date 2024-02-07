# frozen_string_literal: true

# == Schema Information
#
# Table name: endpoints
#
#  id           :bigint           not null, primary key
#  chain        :string           not null
#  discarded_at :datetime
#  http_url     :string           not null
#  is_test      :boolean          default(FALSE), not null
#  network      :string           not null
#  wss_url      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#  quicknode_id :string           not null
#
# Indexes
#
#  index_endpoints_on_account_id    (account_id)
#  index_endpoints_on_discarded_at  (discarded_at)
#  index_endpoints_on_quicknode_id  (quicknode_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Endpoint < ApplicationRecord
  include Discard::Model

  belongs_to :account

  validates :account_id, presence: true
  validates :quicknode_id, presence: true
  validates :chain, presence: true
  validates :network, presence: true
  validates :http_url, presence: true
end
