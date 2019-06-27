# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params, only: %i[create]

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # signature = Signature.new(
    #   image: signature_params[:image],
    #   name: signature_params[:name],
    #   role: signature_params[:role],
    #   rebate_form: rebate_form,
    #   signature_type: signature_type
    # )
    # Signature.transaction do
    #   rebate_form.signatures.where(signature_type: signature_type).delete_all
    #   Signature.create(
    #     image: signature_params[:image],
    #     name: signature_params[:name],
    #     role: signature_params[:role],
    #     rebate_form: rebate_form,
    #     signature_type: signature_type
    #   )
    # end
    # if signature.errors.any?
    #   render_errors_for(signature)
    # else
    #   render_jsonapi(signature, scope: false, include: :signature_type)
    # end
    byebug
    token = params[:data][:token]

    raise JsonapiCompliable::Errors::ValidationError unless token

    decoded_token = decode_jwt(token)[0]

    correct_token(decoded_token)

    rebate_form_id = decoded_token['rebate_form_id']

    instance = RebateForm.find(rebate_form_id)

    signatures = signatures_for_form

    instance.signatures << signatures

    render_jsonapi(signatures, scope: false)
  end

  private

  def signatures_for_form
    sig1_data = params[:data][:signatures][0]
    sig2_data = params[:data][:signatures][1]

    sig1 = instantiate_signature(sig1_data)
    sig2 = instantiate_signature(sig2_data)

    [sig1, sig2]
  end

  def instantiate_signature(data)
    Signature.create(
      image: data[:image],
      name: data[:name],
      role: data[:role],
      signature_type: SignatureType.find_by!(name: data[:type])
    )
  end

  def decode_jwt(token)
    JWT.decode token, ENV['HMAC_SECRET'], true, algorithm: 'HS256'
  end

  def correct_token(decoded_token)
    raise JsonapiCompliable::Errors::RecordNotFound unless decoded_token['per'] == 'sign'
  end

  def signature_params
    params
      .require(:data)
      .require(:signatures)
      .permit(:image, :type, :name, :role)
  end

  # def signature_type
  #   SignatureType.find_by!(name: signature_params[:type])
  # end

  # def rebate_form
  #   RebateForm.find_by!(
  #     # valuation_id: signature_params[:valuation_id]
  #     token: signature_params[:token]
  #   )
  # end

  # def signature_params
  #   params.require(:data).require(:attributes).permit(:valuation_id, :token, :image, :type, :name, :role)
  # end
end
