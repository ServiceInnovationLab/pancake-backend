# frozen_string_literal: true

class RebateFormsController < ApiController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: RebateFormResource

  def show
    scope = jsonapi_scope(RebateForm.where(token: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(instance, scope: false)
  end

  def create
    rebate_form = RebateForm.create(rebate_form_params)
    if rebate_form.errors.any?
      render_errors_for(rebate_form)
    else
      render_jsonapi(rebate_form, scope: false)
    end
  end

  def update
    rebate_form = RebateForm.find_by(token: params[:id])
    rebate_form.update(rebate_form_params)
    if rebate_form.errors.any?
      render_errors_for(rebate_form)
    else
      render_jsonapi(rebate_form, scope: false)
    end
  end

  def rebate_form_params
    params.require(:api).require(:data).require(:attributes).permit(:valuation_id, fields: {})
  end
end
