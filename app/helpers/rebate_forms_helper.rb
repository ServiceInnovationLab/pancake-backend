# frozen_string_literal: true

module RebateFormsHelper
  def rebate_form_pdf_dependants(rebate_form)
    dependants_count = rebate_form.fields['dependants'].to_i || 0
    return pluralize(dependants_count, 'dependant') if dependants_count.positive?

    'None'
  end

  def rebate_form_pdf_home_business(rebate_form)
    rebate_form.fields['has_home_business'] == 'yes' ? 'yes' : 'no'
  end

  def rebate_form_amount(rebate_form)
    "$#{format('%.2f', rebate_form.rebate)}"
  end

  def rebate_form_lived_year?(rebate_form)
    if rebate_form.lived_here.present?
      rebate_form.lived_here.to_s.capitalize
    else
      'No answer'
    end
  end

  def moved_within_rating_year?(rebate_form)
    rebate_form.fields['moved_within_rating_year'] == 'yes'
  end

  def rebate_form_year_header(rebate_form)
    "#{rebate_form.rating_year.to_i - 1}/#{rebate_form.rating_year.to_i} Rates Rebate"
  end

  def rebate_form_has_partner(rebate_form)
    rebate_form_boolean_field_to_english rebate_form.fields['has_partner']
  end

  def last_rating_year(rebate_form)
    rebate_form.property.rating_year.to_i - 1
  end

  def rebate_form_boolean_field_to_english(answer)
    if answer == true || answer.to_s.casecmp('yes').zero?
      'Yes'
    elsif answer == false || answer.to_s.casecmp('no').zero?
      'No'
    elsif answer == '' || answer.nil?
      'No answer'
    else
      answer.to_s.capitalize
    end
  end
end
