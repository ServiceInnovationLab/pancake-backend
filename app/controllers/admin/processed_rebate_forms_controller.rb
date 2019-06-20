# frozen_string_literal: true

class Admin::ProcessedRebateFormsController < Admin::BaseController
  respond_to :json, :html

  def index
    @processed_rebate_forms = policy_scope(RebateForm)
                              .where(status: RebateForm::PROCESSED_STATUS)
                              .order(created_at: :asc)
                              .to_json(include: [:property])

    respond_with json: @processed_rebate_forms.to_json(include: [:property])
  end

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
