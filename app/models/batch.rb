# frozen_string_literal: true

class Batch < ApplicationRecord
  has_many :rebate_forms, dependent: :nullify
  belongs_to :council, required: true
end
