# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = policy_scope(User).with_deleted.order(:email)
  end

  def show; end
  def edit; end

  def update
    if params[:activate].present?
      @user.restore
      redirect_to edit_admin_user_url(@user), notice: 'User was re-actived.'
    else
      @user.update(user_params)
      redirect_to admin_users_url, notice: 'User was updated.'
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'User was de-activated.'
  end

  private

  def set_user
    @user = User.with_deleted.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:council_id, role_ids: [])
  end
end
