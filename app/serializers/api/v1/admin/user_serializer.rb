# frozen_string_literal: true

class Api::V1::Admin::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :admin_request_status, :created_at, :updated_at
end
