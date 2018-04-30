# frozen_string_literal: true

class PropertiesController < ApiController
  jsonapi resource: PropertyResource
  strong_resource :property
  def show
    scope = jsonapi_scope(Property.where(valuation_id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(instance, scope: false,
                             include: [:rates_bills, :rates_payers])
  end

  def index
    # filter = "%#{property_search_params[:location].parameterize}%"
    # properties = Property.where('location ILIKE ?', filter)
    render_jsonapi(Property.all)
  end

  def property_search_params
    params.require(:filter).permit(:location)
  end
end
