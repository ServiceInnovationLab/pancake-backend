# frozen_string_literal: true

class RebateFormsService
  def initialize(rebate_form_attributes)
    @id = rebate_form_attributes[:id]
    @valuation_id = rebate_form_attributes[:valuation_id]
    @create_fields = rebate_form_attributes[:fields]
    @update_fields = rebate_form_attributes[:rebate_form][:fields] if rebate_form_attributes[:rebate_form]
    @location = rebate_form_attributes[:location]
    @total_rates = rebate_form_attributes[:total_rates]
  end

  def update
    property = create_or_update_property
    rebate_form = create_or_update_rebate_form(property)
    update_rates_bill(property)
    rebate_form.calc_rebate_amount!
    raise 'No rebate calculated. This should never happen' if rebate_form.rebate.blank?
    rebate_form
  end

  private

  def create_or_update_rebate_form(property)
    return update_rebate_form(property) if @id
    create_rebate_form(property)
  end

  def update_rebate_form(property)
    rebate_form = RebateForm.find_by(id: @id)
    property = rebate_form.property if property.id.nil?
    rebate_form.update(property: property, valuation_id: property.valuation_id)
    rebate_form.fields.update(@update_fields) unless @update_fields.nil?
    rebate_form
  end

  def create_rebate_form(property)
    RebateForm.create(property: property,
                      valuation_id: property.valuation_id,
                      fields: @create_fields)
  end

  def create_or_update_property
    Property.find_or_create_by(valuation_id: @valuation_id,
                               location: @location,
                               rating_year: ENV['YEAR'])
  end

  def update_rates_bill(property)
    RatesBill.find_or_create_by(property: property,
                                rating_year: property.rating_year,
                                total_rates: @total_rates)
  end
end
