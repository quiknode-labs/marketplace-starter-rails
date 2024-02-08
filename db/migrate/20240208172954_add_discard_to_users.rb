# frozen_string_literal: true

class AddDiscardToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :discarded_at, :datetime
    add_index :users, :discarded_at
  end
end
