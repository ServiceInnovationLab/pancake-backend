# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params, only: %i[create]

  def create
    token = params[:data][:token]

    rebate_form = JwtService.new.decode_signing_token(token)

    if rebate_form.signatures.exists?
      render json: {}, status: :unprocessable_entity
    elsif form_updated_after_token_issue(decoded_token, rebate_form)
      render json: {}, status: :conflict
    else
      signatures = signature_params.map do |signature|
        instantiate_signature(signature, rebate_form)
      end

      render_jsonapi(signatures, scope: false)
    end
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

  def signature_params
    params.require(:data).require(:signatures)
  end

  def token_issued_at(decoded_token)
    decoded_token['exp'] - ENV['IPAD_JWT_LENGTH'].to_i * 60
  end

  def form_updated_after_token_issue(decoded_token, rebate_form)
    token_issued_at(decoded_token) <= rebate_form.updated_at.to_i
  end
end
