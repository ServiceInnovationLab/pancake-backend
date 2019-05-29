# frozen_string_literal: true

class Admin::RebateForms::ProcessController < Admin::BaseController
  respond_to :json

  def index
    @processed_rebate_forms = policy_scope(RebateForm).where(status: RebateForm::PROCESSED_STATUS)
                                                      .order(created_at: :desc)

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
