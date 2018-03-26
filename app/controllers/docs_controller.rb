# frozen_string_literal: true

require 'jsonapi_swagger_helpers'

class DocsController < ActionController::API
  include JsonapiSwaggerHelpers::DocsControllerMixin

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Rates Rebate'
      key :description, '--'
      contact do
        key :name, 'Brenda Wallace'
        key :email, 'brenda.wallace@dia.govt.nz'
      end
    end
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end
  jsonapi_resource '/v1/signature_types'
  jsonapi_resource '/v1/signatures'
  jsonapi_resource '/v1/rebate_forms'
end
