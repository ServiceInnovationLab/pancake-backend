# frozen_string_literal: true

class RebateFormsService
  class Error < StandardError; end

  def initialize(rebate_form_attributes)
    rebate_form_attributes['fields']['location'] = rebate_form_attributes['location'] if rebate_form_attributes['fields']
    @rebate_form_attributes = rebate_form_attributes
  end

  def update!
    council = find_council!
    property = create_or_update_property!(council)
    rebate_form = create_or_update_rebate_form!(property)
    create_or_update_rates_bill!(property)
    rebate_form.calc_rebate_amount!
    raise Error if rebate_form.rebate.blank?
    rebate_form
  end

  private

  def create_or_update_rebate_form!(property)
    return update_rebate_form!(property) if @rebate_form_attributes['id']
    create_rebate_form!(property)
  end

  def update_rebate_form!(property)
    rebate_form = RebateForm.find_by(id: @rebate_form_attributes['id'])
    property = rebate_form.property if property.id.nil?
    remove_signatures_if_completed(rebate_form)
    fields_to_update = rebate_form.fields.merge(fields_to_merge)
    rebate_form.update!(property: property, valuation_id: property.valuation_id, fields: fields_to_update)
    rebate_form
  end

  def remove_signatures_if_completed(rebate_form)
    rebate_form.signatures.destroy_all && rebate_form.update(completed: false) if rebate_form.completed
  end

  def update_fields
    return @rebate_form_attributes['rebate_form']['fields'] if @rebate_form_attributes['rebate_form']
    @rebate_form_attributes['fields']
  end

  def fields_to_merge
    return update_fields unless update_fields.nil?
    {}
  end

  def create_rebate_form!(property)
    RebateForm.create!(property: property,
                       valuation_id: property.valuation_id,
                       rebate: 0,
                       fields: @rebate_form_attributes['fields'])
  end

  def create_or_update_property!(council)
    return create_or_update_property_with_valuation_id!(council) if @rebate_form_attributes['valuation_id']
    find_or_create_property_with_no_valuation_id!(council)
  end

  def create_or_update_property_with_valuation_id!(council)
    property = Property.find_or_create_by(valuation_id: @rebate_form_attributes['valuation_id'],
                                          rating_year: ENV['YEAR'],
                                          council: council)
    property.update!(location: @rebate_form_attributes['location'])
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
    rates_bill.update!(total_rates: @rebate_form_attributes['total_rates'])
    rates_bill
  end
end
