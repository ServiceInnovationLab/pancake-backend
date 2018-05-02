# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params, only: %i[create]

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    signature = Signature.new(
      image: signature_params[:image],
      name: signature_params[:name],
      role: signature_params[:role],
      rebate_form: rebate_form,
      signature_type: signature_type
    )
    Signature.transaction do
      rebate_form.signatures.where(signature_type: signature_type).delete_all
      Signature.create(
        image: signature_params[:image],
        name: signature_params[:name],
        role: signature_params[:role],
        rebate_form: rebate_form,
        signature_type: signature_type
      )
    end
    if signature.errors.any?
      render_errors_for(signature)
    else
      render_jsonapi(signature, scope: false, include: :signature_type)
    end
  end

  private

  def signature_type
    SignatureType.find_by!(name: signature_params[:type])
  end

  def rebate_form
    RebateForm.find_by!(
      # valuation_id: signature_params[:valuation_id]
      token: signature_params[:token]
    )
  end

  def signature_params
    params.require(:data).require(:attributes).permit(:valuation_id, :token, :image, :type, :name, :role)
  end
end
