# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  enum role: { reader: 0, admin: 1 }
  enum admin_request_status: { not_required: 0, requested: 1, accepted: 2, rejected: 3 }

  after_create :add_user_to_sendinblue_list

  def active_for_authentication?
    super && active_user?
  end

  def active_user?
    not_required? || accepted?
  end

  private

  def add_user_to_sendinblue_list
    SendInBlue::AddContactJob.perform_later(id)
  end
end
