# frozen_string_literal: true

class RatesBill < ApplicationRecord
  belongs_to :property, required: true
end
