# frozen_string_literal: true

class SignRebateFormsController < ApiController
  jsonapi resource: SignRebateFormResource
  strong_resource :rebate_form

  def sign
    decoded_token = decode_jwt(params[:data][:token])

    rebate_form_id = decoded_token[0]['rebate_form_id']

    instance = RebateForm.find(rebate_form_id)

    signatures = get_signatures_for_form(instance)

    instance.signatures << signatures

    raise JsonapiCompliable::Errors::RecordNotFound unless instance

    render_jsonapi(signatures, scope: false)
  end

  private

  def get_signatures_for_form(instance)
    sig1_data = params[:data][:signatures][0]
    sig2_data = params[:data][:signatures][1]

    sig1 = instantiate_signature(sig1_data, instance)
    sig2 = instantiate_signature(sig2_data, instance)

    [sig1, sig2]
  end

  def instantiate_signature(data, instance)
    Signature.create(
      image: data[:image],
      name: data[:name],
      role: data[:role],
      rebate_form: instance,
      signature_type: SignatureType.find_by!(name: data[:type])
    )
  end

  def decode_jwt(token)
    JWT.decode token, ENV['HMAC_SECRET'], true, algorithm: 'HS256'
  end

  def signature_params
    params
      .require(:data)
      .require(signatures: [])
      .permit(:image, :type, :name, :role)
  end
end
