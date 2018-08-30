# frozen_string_literal: true

module RebateFormsHelper
  def rebate_form_pdf_dependants(rebate_form)
    dependants_count = rebate_form.fields['dependants'].to_i || 0
    return pluralize(dependants_count, 'dependant') if dependants_count.positive?
    'no'
  end

  def rebate_form_pdf_home_business(rebate_form)
    rebate_form.fields['has_home_business'] == 'yes' ? 'yes' : 'no'
  end

  def rebate_form_amount(rebate_form)
    "$#{format('%.2f', rebate_form.rebate)}"
  end

  def rebate_form_total(rebate_form)
    "$#{format('%.2f', rebate_form.fields['income'])}"
  end
end
