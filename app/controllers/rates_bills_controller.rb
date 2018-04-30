# frozen_string_literal: true

class RatesBillsController < ApiController
  jsonapi resource: RatesBillResource
  strong_resource :rates_bill
end
