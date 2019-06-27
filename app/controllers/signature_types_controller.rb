# frozen_string_literal: true

class SignatureTypesController < ApiController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: SignatureTypeResource

  # Reference a strong resource payload defined in
  # config/initializers/strong_resources.rb
  strong_resource :signature_type
  # Run strong parameter validation for these actions.
  # Invalid keys will be dropped.
  # Invalid value types will log or raise based on the configuration
  # ActionController::Parameters.action_on_invalid_parameters
  before_action :apply_strong_params, only: %i[create update]

  # Start with a base scope and pass to render_jsonapi
  def index
    signature_types = SignatureType.all
    render_jsonapi(signature_types)
  end

  # Call jsonapi_scope directly here so we can get behavior like
  # sparse fieldsets and statistics.
  def show
    scope = jsonapi_scope(SignatureType.where(id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance

    render_jsonapi(instance, scope: false)
  end
end
