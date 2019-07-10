# frozen_string_literal: true

class Admin::SignedRebateFormsController < Admin::BaseController
  respond_to :json, :html

  def index
    @signed_rebate_forms = policy_scope(RebateForm)
                           .kept
                           .where(status: RebateForm::SIGNED_STATUS)
                           .order(created_at: :asc)

    respond_with json: @signed_rebate_forms
  end
end
