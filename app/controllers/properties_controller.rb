# frozen_string_literal: true

class PropertiesController < ApiController
  jsonapi resource: PropertyResource
  strong_resource :property
  def show
    scope = jsonapi_scope(Property.where(valuation_id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(
      instance, scope: false,
                include: %i[rates_bills rates_payers]
    )
  end

  def index
    filter = "%#{params[:q].parameterize}%"
    render_jsonapi(Property.where('location ILIKE ?', filter), include: %i[rates_payers rates_bills])
  end
end
