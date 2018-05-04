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
                   only: %i[create update show],
                   tags: [:rebates],

                   descriptions: {
                     create: 'create a new application for a rates rebate',
                     show: 'retrieve existing application. pass token as id'
                   }
  jsonapi_resource '/v1/signatures',
                   only: %i[create],
                   descriptions: { create: 'create new signature' }

  jsonapi_resource '/v1/properties', only: [:show]

  swagger_path '/v1/properties' do
    operation :get do
      key :summary, 'Suggest addresses'
      parameter do
        key :name, :q
        key :description, 'What the user typed'
        key :required, true
        key :type, :integer
        key :format, :string
      end
    end
  end
end
