# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  include Pundit
  protect_from_forgery
  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
end
