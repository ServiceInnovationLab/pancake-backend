# frozen_string_literal: true

class RatesPayersController < ApiController
  jsonapi resource: RatesPayerResource
  strong_resource :rates_payer
end
