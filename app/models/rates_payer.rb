# frozen_string_literal: true

class RatesPayer < ApplicationRecord
  # For this app, we don't need to show that a
  # rate payer may have maybe properties.
  # We only care about the one they lived in.
  belongs_to :property, required: true
  delegate :council, to: :property

  scope :by_council, -> (council) { joins(:property).where(properties: {council_id: council.id}) }
  scope :by_rating_year, -> (rating_year) { joins(:property).where(properties: {rating_year: rating_year}) }
  
end
