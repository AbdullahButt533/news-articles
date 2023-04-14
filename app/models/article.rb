# frozen_string_literal: true

class Article < ApplicationRecord
  EVERYTHING_PATH = 'everything'
  TOP_HEADLINES_PATH = 'top-headlines'

  validates :url, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }
  validates :content, length: { maximum: 500 }

  belongs_to :author, optional: true
  belongs_to :topic, optional: true

  def self.eager_load_options
    [
      :author,
      :topic
    ]
  end
end
