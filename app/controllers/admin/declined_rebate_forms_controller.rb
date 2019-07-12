# frozen_string_literal: true

class Admin::DeclinedRebateFormsController < Admin::BaseController
  respond_to :json, :html

  def index
    @rebate_forms = policy_scope(RebateForm)
                    .discarded
                    .order(created_at: :asc)

    respond_with json: @rebate_forms
  end
end
