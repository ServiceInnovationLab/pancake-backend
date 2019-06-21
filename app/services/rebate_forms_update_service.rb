# frozen_string_literal: true

class RebateFormsUpdateService
  class Error < StandardError; end

  def initialize(rebate_form_attributes)
    @rebate_form_attributes = rebate_form_attributes
  end

  def update!
    rebate_form = update_rebate_form!

    rebate_form
  end

  private

  def update_rebate_form!
    rebate_form = RebateForm.find_by(id: @rebate_form_attributes['id'])
    remove_signatures_if_signed(rebate_form)
    fields_to_update = rebate_form.fields.merge(fields_to_merge)
    rebate_form.update!(valuation_id: @rebate_form_attributes['valuation_id'],
                        total_rates: @rebate_form_attributes['total_rates'],
                        location: @rebate_form_attributes['location'],
                        fields: fields_to_update)
    rebate_form
  end

  def remove_signatures_if_signed(rebate_form)
    rebate_form.signatures.destroy_all && rebate_form.transition_to_not_signed_state if rebate_form.signed_state?
  end

  def update_fields
    @rebate_form_attributes['fields']
  end

  def fields_to_merge
    return update_fields unless update_fields.nil?

    {}
  end
end
