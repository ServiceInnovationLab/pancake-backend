# frozen_string_literal: true

class RebateFormsService
  class Error < StandardError; end

  def initialize(rebate_form_attributes)
    @rebate_form_attributes = rebate_form_attributes
  end

  def create!
    council = find_council!
    property = find_or_create_property!(council)
    create_rebate_form!(property)
  end

  private

  def create_rebate_form!(property)
    RebateForm.create!(property: property,
                       valuation_id: property.valuation_id,
                       location: property.location,
                       total_rates: total_rates(property),
                       rebate: 0,
                       fields: @rebate_form_attributes['fields'])
  end

  def find_or_create_property!(council)
    return find_or_create_property_with_valuation_id!(council) if @rebate_form_attributes['valuation_id']

    find_or_create_property_with_no_valuation_id!(council)
  end

  def find_or_create_property_with_valuation_id!(council)
    property = Property.find_or_create_by(valuation_id: @rebate_form_attributes['valuation_id'],
                                          rating_year: ENV['YEAR'],
                                          council: council)
    property
  end

  def find_or_create_property_with_no_valuation_id!(council)
    Property.find_or_create_by!(location: @rebate_form_attributes['location'],
                                rating_year: ENV['YEAR'],
                                council: council)
  end

  def find_council!
    Council.find_by!(name: @rebate_form_attributes['council'])
  end

  def create_or_update_rates_bill!(property)
    rates_bill = RatesBill.find_or_create_by(property: property,
                                             rating_year: property.rating_year)
    rates_bill.update!(total_rates: total_rates(property))
    rates_bill
  end

  def total_rates(property)
    property.rates_bills[0]&.total_rates || 0
  end
end
