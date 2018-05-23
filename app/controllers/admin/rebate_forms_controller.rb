# frozen_string_literal: true

class Admin::RebateFormsController < Admin::BaseController
  before_action :set_admin_rebate_form, only: %i[show update destroy]

  # GET /admin/rebate_forms
  def index
    @location = params[:location]
    @rebate_forms = RebateForm.all
                              .includes(:signatures, :property)
                              .order(created_at: :desc)
    if @location.present?
      @rebate_forms = @rebate_forms.joins(:property)
                                   .where('properties.location ILIKE ?', "%#{params[:location]}%")
    end

    @rebate_forms = @rebate_forms.page(params[:page])
  end

  # GET /admin/rebate_forms/1
  def show
    @signatures = {}
    SignatureType.order(:name).all.each do |st|
      @signatures[st.name] = @rebate_form.signatures.where(signature_type: st).order(created_at: :desc).first
    end
  end

  # PATCH/PUT /admin/rebate_forms/1
  def update
    if @rebate_form.update(admin_rebate_form_params)
      redirect_to admin_rebate_form_url(@rebate_form), notice: 'Rebate form was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/rebate_forms/1
  def destroy
    if @rebate_form.fully_signed?
      redirect_to admin_rebate_forms_url, notice: 'Cannot delete signed forms.'
    else
      @rebate_form.destroy
      redirect_to admin_rebate_forms_url, notice: 'Rebate form was successfully destroyed.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_rebate_form
    @rebate_form = RebateForm.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def admin_rebate_form_params
    params.require(:rebate_form).permit(:valuation_id, :token, attachments: [])
  end
end
