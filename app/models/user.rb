# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  enum role: { reader: 0, admin: 1 }
  enum admin_request_status: { not_required: 0, requested: 1, accepted: 2, rejected: 3 }
end
