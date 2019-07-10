# frozen_string_literal: true

class SignaturesController < ApiController
  jsonapi resource: SignatureResource
  strong_resource :signature
  before_action :apply_strong_params, only: %i[create]

  def create
    rebate_form = JwtService.new.decode_signing_token(params[:data][:token])

    return render json: { message: 'Rebate form has already signed.' }, status: :unprocessable_entity if rebate_form.signatures.exists?

    instantiate_signatures(rebate_form)

    render_jsonapi(signatures, scope: false)
  rescue JwtService::StalePayloadError => e
    render json: { message: e.message }, status: :conflict
  end

  private

  def instantiate_signatures(rebate_form)
    signature_params.each do |signature|
      Signature.create(
        image: signature[:image],
        name: signature[:name],
        role: signature[:role],
        signature_type: SignatureType.find_by!(name: signature[:type]),
        rebate_form: rebate_form
      )
    end
  end

  def signature_params
    params.require(:data).require(:signatures)
  end
end
