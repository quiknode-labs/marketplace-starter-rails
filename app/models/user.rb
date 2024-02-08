# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  discarded_at      :datetime
#  email             :string
#  name              :string
#  organization_name :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint           not null
#
# Indexes
#
#  index_users_on_account_id    (account_id)
#  index_users_on_discarded_at  (discarded_at)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class User < ApplicationRecord
  include Discard::Model

  belongs_to :account

  validates :account_id, presence: true
  validates :email, presence: true
end
