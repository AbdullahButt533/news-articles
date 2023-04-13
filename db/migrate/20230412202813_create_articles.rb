# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.jsonb :source, default: {}
      t.text :description, limit: 500
      t.string :url, null: false
      t.string :url_to_image
      t.text :content, limit: 500
      t.datetime :published_at
      t.references :topic, null: true, foreign_key: true
      t.references :author, null: true, foreign_key: true

      t.timestamps
    end
    add_index :articles, :url, unique: true
  end
end
