# frozen_string_literal: true

class RebateFormsController < ApiController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: RebateFormResource

  # Reference a strong resource payload defined in
  # config/initializers/strong_resources.rb
  strong_resource :rebate_form
  # Run strong parameter validation for these actions.
  # Invalid keys will be dropped.
  # Invalid value types will log or raise based on the configuration
  # ActionController::Parameters.action_on_invalid_parameters
  before_action :apply_strong_params, only: %i[create update]

  # Start with a base scope and pass to render_jsonapi
  # def index
  #   rebate_forms = RebateForm.all
  #   render_jsonapi(rebate_forms)
  # end

  # Call jsonapi_scope directly here so we can get behavior like
  # sparse fieldsets and statistics.
  def show
    scope = jsonapi_scope(RebateForm.where(token: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(instance, scope: false)
  end

  # jsonapi_create will use the configured Resource (and adapter) to persist.
  # This will handle nested relationships as well.
  # On validation errors, render correct error JSON.
  def create
    rebate_form, success = jsonapi_create.to_a
    fields = params[:_jsonapi][:data][:attributes][:fields].to_json
    rebate_form.update(fields: fields)

    if success
      render_jsonapi(rebate_form, scope: false)
    else
      render_errors_for(rebate_form)
    end
  end

  # jsonapi_update will use the configured Resource (and adapter) to persist.
  # This will handle nested relationships as well.
  # On validation errors, render correct error JSON.
  def update
    rebate_form, success = jsonapi_update.to_a
    fields = params[:_jsonapi][:data][:attributes][:fields].to_json
    rebate_form.update(fields: fields)

    if success
      render_jsonapi(rebate_form, scope: false)
    else
      render_errors_for(rebate_form)
    end
  end

  # Renders 200 OK with empty meta
  # http://jsonapi.org/format/#crud-deleting-responses-200
  # def destroy
  #   rebate_form, success = jsonapi_destroy.to_a

  #   if success
  #     render json: { meta: {} }
  #   else
  #     render_errors_for(rebate_form)
  #   end
  # end
end
