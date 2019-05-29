# frozen_string_literal: true

module Admin::CouncilsHelper
  def council_forms_count(council)
    council.rebate_forms.size
  end

  def council_forms_sum(council)
    "$#{format('%.2f', council.rebate_forms.sum(:rebate))}"
  end

  def council_signed_forms_count(council)
    council.rebate_forms.where(status: RebateForm::SIGNED_STATUS).size
  end

  def council_percentage_signed(council)
    signed = council_signed_forms_count(council).to_f
    total = council_forms_count(council).to_f
    return '-' unless signed && total.positive?

    percent =  signed / total
    percent *= 100
    "#{percent.to_i}%"
  end

  def council_signed_forms_sum(council)
    "$#{format('%.2f', council.rebate_forms.where(status: RebateForm::SIGNED_STATUS).sum(:rebate))}"
  end

  def council_signed_batched_forms_count(council)
    council.rebate_forms.where(status: RebateForm::SIGNED_STATUS, batch_id: nil).size
  end

  def council_signed_batched_forms_sum(council)
    "$#{format('%.2f', council.rebate_forms.where(status: RebateForm::SIGNED_STATUS, batch_id: nil).sum(:rebate))}"
  end
end
