# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def after_sign_in_path_for(_resource)
    admin_rebate_forms_path
  end
end
