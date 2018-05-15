# frozen_string_literal: true

class RatesBill < ApplicationRecord
  belongs_to :property, required: true

  def total_bill
    self.total_rates.to_f + self.total_water_rates.to_f
  end
end
