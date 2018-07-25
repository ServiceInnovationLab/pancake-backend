# frozen_string_literal: true

class Admin::SignaturesController < Admin::BaseController
  def show
    @signature = rebate_form.signatures.where(signature_type_id: signature_type.id).order(created_at: :desc).first
    authorize @signature
    send_data Base64.decode64(@signature.image), type: 'image/png', disposition: 'inline'
  end

  private

  def rebate_form
    RebateForm.find_by(token: params[:token], valuation_id: params[:valuation_id])
  end

  def signature_type
    SignatureType.find_by(name: params[:type])
  end
end
