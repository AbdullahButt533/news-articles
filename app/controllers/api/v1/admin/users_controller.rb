# frozen_string_literal: true

class Api::V1::Admin::UsersController < Api::V1::Admin::ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    render json: @user, status: :created if @user.save!
  end

  def update
    render json: @user if @user.update!(user_params)
  end

  def destroy
    @user.destroy!
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :role, :admin_request_status)
  end
end
