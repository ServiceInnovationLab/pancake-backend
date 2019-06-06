# frozen_string_literal: true

class Admin::SignRebateFormsController < Admin::BaseController
  respond_to :json

  def index
    @signed_rebate_forms = policy_scope(RebateForm)
                           .where(status: RebateForm::SIGNED_STATUS)
                           .order(created_at: :asc)

    respond_with json: @signed_rebate_forms.to_json
  end
end
