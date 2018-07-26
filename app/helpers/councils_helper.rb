# frozen_string_literal: true

module CouncilsHelper
  def council_forms_count(council)
    council.rebate_forms.size
  end

  def council_forms_sum(council)
    "$#{sprintf('%.2f', council.rebate_forms.sum(:rebate))}"
  end

  def council_completed_forms_count(council)
    council.rebate_forms.where(completed: true).size
  end

  def council_percentage_completed(council)
    percent = council_completed_forms_count(council).to_f / council_forms_count(council).to_f
    percent = percent * 100
    "#{percent.to_i}%"
  end

  def council_completed_forms_sum(council)
    "$#{council.rebate_forms.where(completed: true).sum(:rebate)}"
  end

  def council_completed_batched_forms_count(council)
    council.rebate_forms.where(completed: true, batch_id: nil).size
  end

  def council_completed_batched_forms_sum(council)
    "$#{council.rebate_forms.where(completed: true, batch_id: nil).sum(:rebate)}"
  end
end
