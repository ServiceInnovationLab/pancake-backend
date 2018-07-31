# frozen_string_literal: true

class Admin::RebateFormsController < Admin::BaseController
  before_action :set_rebate_form, only: %i[show update destroy]

  # GET /admin/rebate_forms
  def index
    @location = params[:location]
    @council = current_user.council.presence
    @rebate_forms = policy_scope(RebateForm).all
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
    @year = ENV['YEAR']

    @rates_bill = @rebate_form.property.rates_bills.find_by(rating_year: @year)

    @signatures = {}
    SignatureType.order(:name).all.each do |st|
      @signatures[st.name] = @rebate_form.signatures.where(signature_type: st).order(created_at: :desc).first
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: pdf_filename, page_size: 'A4', layout: 'pdf'
      end
    end
  end

  # PATCH/PUT /admin/rebate_forms/1
  def update
    if @rebate_form.update(rebate_form_params)
      redirect_to admin_rebate_forms_url, notice: 'Rebate form was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/rebate_forms/1
  def destroy
    if @rebate_form.completed
      redirect_to admin_rebate_forms_url, notice: 'Cannot delete signed forms.'
    else
      @rebate_form.destroy
      redirect_to admin_rebate_forms_url, notice: 'Rebate form was successfully destroyed.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rebate_form
    @rebate_form = RebateForm.find(params[:id])
    authorize @rebate_form
  end

  # Only allow a trusted parameter "white list" through.
  def rebate_form_params
    params.require(:rebate_form).permit(:valuation_id, :token, attachments: [])
  end

  def pdf_filename
    "rebate-#{@rebate_form.council.short_name}-#{@rebate_form.id}"
  end
end
