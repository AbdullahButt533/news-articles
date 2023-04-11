# frozen_string_literal: true

class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_error_not_confirmed
    return super if @resource.active_user?

    render json: build_inactive_response, status: :unauthorized
  end

  private

  def build_inactive_response
    {
      success: false,
      errors: [I18n.t('inactive')],
    }
  end
end
