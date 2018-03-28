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
                   only: [:create],
                   descriptions: { create: 'create a new application for a rates rebate' }

  jsonapi_resource '/v1/signature_types',
                   only: [:index],
                   descriptions: { index: 'list of possible signature types' }

  jsonapi_resource '/v1/signatures',
                   only: [:create, :update],
                   descriptions: { create: 'create new signture', update: 'overwrite existing signature' }
end
