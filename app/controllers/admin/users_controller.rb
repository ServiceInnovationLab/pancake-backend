# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = policy_scope(User).with_deleted.order(:email)
  end

  def edit; end

  def show; end

  def update
    if params[:activate].present?
      @user.restore
      redirect_to edit_admin_user_url(@user), notice: 'User was re-actived.'
    else
      if @user.update(user_params)
        redirect_to admin_users_url, notice: 'User was updated.'
      else
        render :edit
      end
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
    u = params.require(:user).permit(:name, :council_id, role_ids: [])
    u[:council_id] = nil if u[:council_id].blank?
    u[:role_ids] = [] if u[:role_ids].blank?
    u
  end
end
