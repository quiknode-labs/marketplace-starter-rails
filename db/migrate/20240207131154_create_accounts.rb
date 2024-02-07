# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :quicknode_id, index: true, null: false
      t.string :plan_slug, null: false
      t.boolean :is_test, null: false, default: false

      t.timestamps
    end
  end
end
