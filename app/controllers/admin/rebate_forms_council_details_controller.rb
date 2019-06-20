# frozen_string_literal: true

class Admin::RebateFormsCouncilDetailsController < Admin::BaseController
  def edit
    @rebate_form = RebateForm.find(params[:rebate_form_id])
    authorize @rebate_form
  end

  def update
    rebate_form = RebateForm.find(params['id'])
    rebate_form.update!(valuation_id: rebate_form_council_details_params['valuation_id'],
                        customer_id: rebate_form_council_details_params['customer_id'],
                        application_id: rebate_form_council_details_params['application_id'])

    redirect_to admin_rebate_form_path(rebate_form)
  end

  private

  def rebate_form_council_details_params
    params.require(:rebate_form).permit(:customer_id, :valuation_id, :application_id)
  end
end
