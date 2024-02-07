# frozen_string_literal: true

class CreateEndpoints < ActiveRecord::Migration[7.1]
  def change
    create_table :endpoints do |t|
      t.references :account, null: false, foreign_key: true
      t.string :quicknode_id, null: false, index: true
      t.string :chain, null: false
      t.string :network, null: false
      t.string :wss_url
      t.string :http_url, null: false
      t.boolean :is_test, null: false, default: false

      t.timestamps
    end
  end
end
