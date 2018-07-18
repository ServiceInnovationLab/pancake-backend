# frozen_string_literal: true

class RatesPayer < ApplicationRecord
  # For this app, we don't need to show that a
  # rate payer may have maybe properties.
  # We only care about the one they lived in.
  belongs_to :property, required: true
  delegate :council, to: :property
end
