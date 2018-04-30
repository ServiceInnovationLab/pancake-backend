# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params

  def create
    Signature.transaction do
      delete_existing_signatures!
      signature.save
    end
    return render_errors_for(signature) if signature.errors.any?
    render_jsonapi(signature, scope: false)
  end

  private

  def delete_existing_signatures!
    rebate_form.signatures.where(signature_type: signature_type).delete_all
  end

  def signature
    Signature.new(
      image: signature_params[:image],
      name: signature_params[:name],
      role: signature_params[:role],
      rebate_form: rebate_form,
      signature_type: signature_type
    )
  end

  def signature_type
    SignatureType.find_by(name: signature_params[:type])
  end

  def rebate_form
    RebateForm.find_by(
      valuation_id: signature_params[:valuation_id], token: signature_params[:token]
    )
  end

  def signature_params
    params.require(:data).require(:attributes).permit(:valuation_id, :token, :image, :type, :name, :role)
  end
end
