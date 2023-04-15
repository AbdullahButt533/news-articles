# frozen_string_literal: true

class Author < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :articles, dependent: :destroy
  has_many :topics, through: :articles
end
