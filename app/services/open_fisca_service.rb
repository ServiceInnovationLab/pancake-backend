# frozen_string_literal: true

require 'httparty'
require 'json'

class OpenFiscaService
  def self.rebate_amount(income:, rates:, dependants:, year:)
    property_name = 'tahi'
    query = {
      'persons' => {
        'Ruby' => {
          'salary' => {
            year => income,
          },
          'dependants' => {
            year => dependants,
          },
        },
      },
      'properties' => {
        property_name => {
          'owners' => ['Ruby'],
          'rates' => {
            year => rates,
          },
          'rates_rebate' => {
            year => nil,
          },
        },
      },
    }
    response = calculate(query)
    response['properties'][property_name]['rates_rebate'][year]
  end

  def self.calculate(query)
    headers = { 'Content-Type' => 'application/json' }
    JSON.parse(HTTParty.post(ENV['OPENFISCA_ORIGIN'], body: query.to_json,
                                                      headers: headers).body)
  end
end
