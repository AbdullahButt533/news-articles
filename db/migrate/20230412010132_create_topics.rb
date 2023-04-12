# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :title, null: false

      t.timestamps
    end
    add_index :topics, :title, unique: true
  end
end
