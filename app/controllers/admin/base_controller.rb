# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  include Pundit
  protect_from_forgery
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'
    respond_to do |format|
      format.html { render(filed: 'public/403.html', status: :forbidden) }
      format.json { render(json: { error: flash[:error] }, status: :forbidden) }
    end
  end

  def not_found
    render file: 'public/404.html', status: :not_found, layout: false
  end
end
