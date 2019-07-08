# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params, only: %i[create]
  respond_to :json

  def create
    token = params[:data][:token]

    rebate_form = JwtService.new.decode_signing_token(token)

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

  def signature_params
    params.require(:data).require(:signatures)
  end
end
