# frozen_string_literal: true

class Batch < ApplicationRecord
  has_many :rebate_forms
  belongs_to :council
end
