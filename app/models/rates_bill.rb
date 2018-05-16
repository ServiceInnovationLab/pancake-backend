# frozen_string_literal: true

class RatesBill < ApplicationRecord
  belongs_to :property, required: true

  def total_bill
    '%.2f' % (total_rates.to_f + total_water_rates.to_f)
  end
end
