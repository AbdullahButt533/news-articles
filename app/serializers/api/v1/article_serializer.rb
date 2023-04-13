# frozen_string_literal: true

class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :source, :description, :url, :url_to_image, :content, :published_at, :created_at, :updated_at

  belongs_to :topic, serializer: Api::V1::TopicSerializer
  belongs_to :author, serializer: Api::V1::AuthorSerializer
end
