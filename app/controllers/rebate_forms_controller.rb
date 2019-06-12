# frozen_string_literal: true

class RebateFormsController < ApiController
  jsonapi resource: RebateFormResource
  strong_resource :rebate_form

  def show_by_jwt
    token = params[:jwt]

    raise JsonapiCompliable::Errors::RecordNotFound unless token

    decoded_token = decode_jwt(token)[0]

    correct_token(decoded_token)

    rebate_form_id = decoded_token['rebate_form_id']

    rebate_form = RebateForm.find(rebate_form_id)

    rebate_form.fields['total_rates'] = rebate_form.property.rates_bills[0].total_rates

    rebate_form.fields['location'] = rebate_form.property.location

    raise JsonapiCompliable::Errors::RecordNotFound unless rebate_form

    render_jsonapi(rebate_form, scope: false)
  end

  def create
    rebate_form = RebateFormsService.new(rebate_form_params).update!

    render_jsonapi(rebate_form, scope: false)
  rescue RebateFormsService::Error
    render_errors_for(rebate_form)
  end

  private

  def rebate_form_params
    params
      .require(:api)
      .require(:data)
      .require(:attributes)
      .permit(:id,
              :valuation_id,
              :council,
              :total_rates,
              :location,
              fields: {},
              applicant_signature: {},
              witness_signature: {})
  end

  def decode_jwt(token)
    JWT.decode token, ENV['HMAC_SECRET'], true, algorithm: 'HS256'
  end

  def correct_token(decoded_token)
    raise JsonapiCompliable::Errors::RecordNotFound unless decoded_token['per'] == 'sign'
  end
end
