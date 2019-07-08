# frozen_string_literal: true

module FormattingHelper
  include ActionView::Helpers::NumberHelper

  # Replicates currency formatting used in the iPad UI javascript (formatDollars function)
  def currency_like_ipad(number)
    # Note the return value should probably be '$0' but this matches the js implementation
    return '$0.00' if number.blank?

    string_value = number_to_currency(number)

    # drop decimal for whole dollars
    return string_value[0..-4] if string_value[-3, 3] == '.00'

    string_value
  end
end
