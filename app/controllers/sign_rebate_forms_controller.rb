# frozen_string_literal: true

class SignRebateFormsController < ActionController::API
  def sign
    decoded_token = decode_jwt(params[:data][:token])

    rebate_form_id = decoded_token[0]['rebate_form_id']

    instance = RebateForm.find(rebate_form_id)

    sig1_data = params[:data][:signatures][0]
    sig2_data = params[:data][:signatures][1]

    sig1 = instantiate_signature(sig1_data, instance)
    sig2 = instantiate_signature(sig2_data, instance)

    instance.signatures << [sig1, sig2]

    # what would a good error message be?

    # maybe change this to just 200 "i did things"
    # render_jsonapi(instance, scope: false)
  end

  private

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
      .permit(signatures: [])
      .permit(:image, :type, :name, :role)
  end
end
