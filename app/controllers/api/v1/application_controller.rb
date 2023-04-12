# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  include ErrorHandler

  respond_to :json

  before_action :authenticate_user!

  def self.responder
    JsonResponder
  end
end
