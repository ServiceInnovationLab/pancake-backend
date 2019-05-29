# frozen_string_literal: true

class Admin::ProcessRebateFormsController < Admin::BaseController
  def index
    @processed_rebate_forms = RebateForm.where(status: RebateForm::PROCESSED_STATE)

    respond_with json: @processed_rebate_forms.to_json
  end

  def create
    rebate_form_to_process = RebateForm.find(params[:id])

    rebate_form_to_process.transition_to_processed_state
  end

  def destroy
    rebate_forms_to_unprocess = params[:ids].map { |id| RebateForm.find(id) }

    rebate_forms_to_unprocess.map(&:transition_to_signed_state)
  end
end
