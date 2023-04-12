# frozen_string_literal: true

class Api::V1::TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at
end
