# frozen_string_literal: true

class RebateFormsController < ApiController
  jsonapi resource: RebateFormResource
  # strong_resource :rebate_form

  def index
    decoded_token = decode_jwt(params[:t])

    rebate_form_id = decoded_token[0]['rebate_form_id']

    rebate_form = RebateForm.find(rebate_form_id)

    fields = rebate_form['fields']

    # response = {
    #   full_name: fields['full_name'],
    #   total_income: fields['income']['total_income'],
    #   occupation: fields['occupation'],
    #   location: fields['location'],
    #   lived_in_property_1_July: fields['lived_in_property_1_July'],
    #   total_rates: fields['total_rates'],
    #   dependants: fields['dependants'],
    #   spouse_or_partner: fields['spouse_or_partner']
    # }

    render_jsonapi(rebate_form, scope: false)
  end

  def create
    rebate_form = RebateFormsService.new(rebate_form_params).update

    if rebate_form.errors.any?
      render_errors_for(rebate_form)
    else
      render_jsonapi(rebate_form, scope: false)
    end
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
end
