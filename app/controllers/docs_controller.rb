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
  jsonapi_resource '/v1/rebate_forms',
                   only: %i[create show update],
                   descriptions: {
                     create: 'create a new application for a rates rebate',
                     show: 'retrieve existing application. pass token as id'
                   }
  jsonapi_resource '/v1/signatures',
                   only: %i[create],
                   descriptions: { create: 'create new signature' }
end
