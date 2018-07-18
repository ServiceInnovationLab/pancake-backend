# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]

  def index
    @users = User.with_deleted.order(:email)
  end

  def show; end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'User was de-activated.'
  end

  private

  def set_user
    @user = User.with_deleted.find(params[:id])
  end
end
