# frozen_string_literal: true

class Batch < ApplicationRecord
  has_many :rebate_forms, dependent: :nullify
  belongs_to :council, optional: false
  after_create :add_temp_name

  private

  def add_temp_name
    update!(name: "TEMP-BATCH-ID##{id}")
  end
end
