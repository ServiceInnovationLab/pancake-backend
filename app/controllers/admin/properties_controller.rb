class Admin::PropertiesController < Admin::BaseController
  def index
    @council = Council.find params[:council_id]
    @properties = policy_scope Property.where(council: @council).includes(:council).order(:location).page(params[:page])
  end
end
