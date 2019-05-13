# frozen_string_literal: true

class RebateFormsService
  def initialize(rebate_form_attributes)
    @rebate_form_attributes = rebate_form_attributes
  end

  def update
    council = find_council
    property = create_or_update_property(council)
    rebate_form = create_or_update_rebate_form(property)
    update_rates_bill(property)
    rebate_form.calc_rebate_amount!
    raise 'No rebate calculated. This should never happen' if rebate_form.rebate.blank?
    rebate_form
  end

  private

  def create_or_update_rebate_form(property)
    return update_rebate_form(property) if @rebate_form_attributes['id']
    create_rebate_form(property)
  end

  def update_rebate_form(property)
    rebate_form = RebateForm.find_by(id: @rebate_form_attributes['id'])
    property = rebate_form.property if property.id.nil?
    fields_to_update = rebate_form.fields.merge(fields_to_merge)
    rebate_form.update(property: property, valuation_id: property.valuation_id, fields: fields_to_update)
    rebate_form
  end

  def update_fields
    return @rebate_form_attributes['rebate_form']['fields'] if @rebate_form_attributes['rebate_form']
    @rebate_form_attributes['fields']
  end

  def fields_to_merge
    return update_fields unless update_fields.nil?
    {}
  end

  def create_rebate_form(property)
    RebateForm.create(property: property,
                      valuation_id: property.valuation_id,
                      fields: @rebate_form_attributes['fields'])
  end

  def create_or_update_property(council)
    Property.find_or_create_by(valuation_id: @rebate_form_attributes['valuation_id'],
                               location: @rebate_form_attributes['location'],
                               rating_year: ENV['YEAR'],
                               council: council)
  end

  def find_council
    Council.find_by(name: @rebate_form_attributes['council'])
  end

  def update_rates_bill(property)
    RatesBill.find_or_create_by(property: property,
                                rating_year: property.rating_year,
                                total_rates: @rebate_form_attributes['total_rates'])
  end
end
