# frozen_string_literal: true

class Batch < ApplicationRecord
  has_many :rebate_forms, dependent: :nullify
  belongs_to :council, optional: false
  after_create :add_temp_name

  has_one_attached :header_sheet

  validates :council, presence: true
  # Each rebate form validates that its council matches the batch council
  validates_associated :rebate_forms

  def erms_header_sheet_attached?
    header_sheet.attached?
  end

  private

  def add_temp_name
    update!(name: "TEMP-BATCH-ID##{id}")
  end
end
