# frozen_string_literal: true

class PropertiesController < ApiController
  jsonapi resource: PropertyResource
  strong_resource :property
end
