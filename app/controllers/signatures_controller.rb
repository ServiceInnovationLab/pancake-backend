# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params, only: %i[create]

  def create
    token = params[:data][:token]

    raise JsonapiCompliable::Errors::ValidationError unless token

    decoded_token = decode_jwt(token)

    rebate_form = RebateForm.find(decoded_token['rebate_form_id'])

    signatures = signature_params.map do |signature|
      instantiate_signature(signature, rebate_form)
    end

    render_jsonapi(signatures, scope: false)
  end

  private

  def instantiate_signature(signature, rebate_form)
    Signature.create(
      image: signature[:image],
      name: signature[:name],
      role: signature[:role],
      signature_type: SignatureType.find_by!(name: signature[:type]),
      rebate_form: rebate_form
    )
  end

  def decode_jwt(token)
    decoded_token = (JWT.decode token, ENV['HMAC_SECRET'], true, algorithm: 'HS256').first

    correct_token(decoded_token)

    decoded_token
  end

  def correct_token(decoded_token)
    raise JsonapiCompliable::Errors::RecordNotFound unless decoded_token['per'] == 'sign'
  end

  def signature_params
    params.require(:data).require(:signatures)
  end
end
