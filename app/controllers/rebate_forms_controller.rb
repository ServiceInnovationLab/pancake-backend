# frozen_string_literal: true

class RebateFormsController < ApiController
  jsonapi resource: RebateFormResource
  strong_resource :rebate_form

  def show_by_jwt
    token = params[:jwt]

    rebate_form = JwtService.new.decode_for_rebate_form_signing(token)

    render_jsonapi(rebate_form, scope: false)
  end

  def create
    rebate_form = RebateFormsService.new(rebate_form_params).create!

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
      .permit(:valuation_id,
              :council,
              :location,
              :total_rates,
              fields: {},
              applicant_signature: {},
              witness_signature: {})
  end
end
