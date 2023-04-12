# frozen_string_literal: true

class Api::V1::AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
end
