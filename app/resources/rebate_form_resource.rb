# frozen_string_literal: true

class RebateFormResource < JSONAPI::Resource
  attribute :token
  attribute :payload
  has_many :signatures
end
