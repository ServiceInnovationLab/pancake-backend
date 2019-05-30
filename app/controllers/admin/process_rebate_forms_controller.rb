# frozen_string_literal: true

class Admin::ProcessRebateFormsController < Admin::BaseController
  respond_to :json

  def create
    rebate_form_to_process = RebateForm.find(params[:id])
    authorize rebate_form_to_process, policy_class: ProcessRebateFormsPolicy
    rebate_form_to_process.transition_to_processed_state

    redirect_to admin_rebate_form_path(rebate_form_to_process.id), notice: 'The application was processed.'
  end

  def destroy_all
    rebate_forms_to_unprocess = params[:ids].map { |id| RebateForm.find(id) }

    RebateForm.transaction do
      rebate_forms_to_unprocess.map do |rebate_form|
        authorize rebate_form, policy_class: ProcessRebateFormsPolicy
        rebate_form.transition_to_signed_state
      end
    end
  end

  def destroy
    rebate_form_to_unprocess = RebateForm.find(params[:id])

    authorize rebate_form_to_unprocess, policy_class: ProcessRebateFormsPolicy

    rebate_form_to_unprocess.transition_to_signed_state

    redirect_to admin_rebate_form_path(rebate_form_to_unprocess.id), notice: 'The application was unprocessed.'
  end
end
