# frozen_string_literal: true

class Batch < ApplicationRecord
  has_many :rebate_forms, dependent: :nullify
  belongs_to :council, optional: false
  after_create :add_temp_name
  after_update :update_cover_sheet_flag

  has_one_attached :cover_sheet

  def cover_sheet_attached?
    cover_sheet.attached?
  end

  private

  def add_temp_name
    update!(name: "TEMP-BATCH-ID##{id}")
  end

  def update_cover_sheet_flag
    update!(cover_sheet_attached: true) if cover_sheet_attached?
  end
end
