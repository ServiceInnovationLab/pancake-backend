# frozen_string_literal: true

class ApiController < ActionController::API
  # Bootstrap jsonapi_suite with relevant modules
  include JsonapiSuite::ControllerMixin

  # register_exception JsonapiCompliable::Errors::RecordNotFound,
  #                    status: 404

  # Catch all exceptions and render a JSONAPI-compliable error payload
  # For additional documentation, see https://jsonapi-suite.github.io/jsonapi_errorable
  # rescue_from Exception do |e|
  #   handle_exception(e)
  # end

  rescue_from JwtService::StalePayloadError do |exception|
    Rails.logger.info("Handled as 409 Conflict: #{exception.message}")
    render json: { message: exception.message }, status: :conflict
  end
end
