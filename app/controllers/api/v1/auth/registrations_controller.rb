# frozen_string_literal: true

class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      resource.requested! if params[:is_admin]
    end
  end
end
