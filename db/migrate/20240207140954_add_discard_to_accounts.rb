# frozen_string_literal: true

class AddDiscardToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :discarded_at, :datetime
    add_index :accounts, :discarded_at
  end
end
