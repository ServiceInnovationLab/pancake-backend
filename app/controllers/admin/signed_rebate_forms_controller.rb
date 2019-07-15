# frozen_string_literal: true

class Admin::SignedRebateFormsController < Admin::BaseController
  skip_after_action :verify_authorized
  after_action :verify_policy_scoped

  def index
    @signed_rebate_forms = policy_scope(RebateForm)
                           .kept
                           .where(status: RebateForm::SIGNED_STATUS)
                           .order(created_at: :asc)
  end

  def download_csv
    @signed_rebate_forms = policy_scope(RebateForm)
                           .where(status: RebateForm::SIGNED_STATUS)
                           .order(created_at: :asc)

    send_data @signed_rebate_forms.to_csv, filename: "Rebate-Forms-#{Time.zone.today}.csv", disposition: 'attachment'
  end
end
