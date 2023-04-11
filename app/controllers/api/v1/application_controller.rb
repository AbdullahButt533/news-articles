# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_user!
end
