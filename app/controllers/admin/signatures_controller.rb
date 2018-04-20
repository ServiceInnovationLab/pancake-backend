# frozen_string_literal: true

class Admin::SignaturesController < Admin::BaseController
  def show
    @rebate_form = RebateForm.find_by(token: params[:token], valuation_id: params[:valuation_id])
    @signature_type = SignatureType.find_by(name: params[:type])
    @signature = @rebate_form.signatures.find_by(signature_type_id: @signature_type.id)
    send_data Base64.decode64(@signature.image), type: 'image/png', disposition: 'inline'
  end
end
