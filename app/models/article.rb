# frozen_string_literal: true

class Article < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }
  validates :content, length: { maximum: 500 }

  belongs_to :author, optional: true
  belongs_to :topic, optional: true
end
