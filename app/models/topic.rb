# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :articles, dependent: :destroy
  has_many :authors, through: :articles
end
