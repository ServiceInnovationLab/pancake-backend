# frozen_string_literal: true

class SignRebateFormsController < ApiController
  jsonapi resource: SignRebateFormResource
  strong_resource :rebate_form

  def sign
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
end
