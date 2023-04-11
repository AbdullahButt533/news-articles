# frozen_string_literal: true

class Api::V1::Admin::ApplicationController < Api::V1::ApplicationController
  before_action :authorize_admin_access!

  private

  def authorize_admin_access!
    return if current_user.admin?

    head(:forbidden)
  end
end
