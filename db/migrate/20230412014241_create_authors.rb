# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :authors, :name, unique: true
  end
end
