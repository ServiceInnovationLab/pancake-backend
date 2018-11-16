# frozen_string_literal: true

class CouncilsController < ApiController
  jsonapi resource: CouncilResource
  strong_resource :council
  def show
    scope = jsonapi_scope(Council.where(short_name: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance

    render_jsonapi(instance, scope: false)
  end

  def index
    render_jsonapi(Council.where(active: true))
  end
end
