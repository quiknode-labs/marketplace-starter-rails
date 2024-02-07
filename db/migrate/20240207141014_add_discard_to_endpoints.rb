# frozen_string_literal: true

class AddDiscardToEndpoints < ActiveRecord::Migration[7.1]
  def change
    add_column :endpoints, :discarded_at, :datetime
    add_index :endpoints, :discarded_at
  end
end
