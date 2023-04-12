# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
