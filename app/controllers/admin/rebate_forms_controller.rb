# frozen_string_literal: true

class Admin::RebateFormsController < Admin::BaseController
  before_action :set_rebate_form, only: %i[show update destroy edit]
  respond_to :html, :pdf, :csv, :json

  def generateqr
    @rebate_form = RebateForm.find(params[:rebate_form_id])
    authorize @rebate_form

    @image_data = RebateFormsService.new(rebate_form_fields_params).generate_qr(@rebate_form)
  end

  # GET /admin/rebate_forms
  def index
    @name = params[:name]

    @completed = (params[:completed] == 'true')

    @council = current_user.council.presence

    @rebate_forms = policy_scope(RebateForm).joins(:property)
                                            .includes(:signatures, :property, property: :council)
                                            .order(created_at: :desc)

    # filter by the search form fields
    @rebate_forms = @rebate_forms.where("fields ->> 'full_name' like ?", "%#{params[:name]}%") if @name.present?
    @rebate_forms = @rebate_forms.where(completed: @completed)
    @rebate_forms = @rebate_forms.order(created_at: :desc)

    respond_with json: @rebate_forms.to_json(include: [:property])
  end

  # GET /admin/rebate_forms/1
  def show
    @year = @rebate_form.property.rating_year

    @rates_bill = @rebate_form.property.rates_bills.find_by(rating_year: @year)

    @signatures = {}
    SignatureType.order(:name).all.each do |st|
      @signatures[st.name] = @rebate_form.signatures.where(signature_type: st).order(created_at: :desc).first
    end

    @updated_by = User.find(@rebate_form.updated_by) unless @rebate_form.updated_by.nil?

    respond_with(@rebate_form) do |format|
      format.pdf do
        render pdf: pdf_filename, page_size: 'A4', layout: 'pdf', margin: { top: 0, bottom: 0, left: 0, right: 0 }, dpi: '300'
      end
    end
  end

  def edit; end

  # PATCH/PUT /admin/rebate_forms/1
  def update
    @rebate_form = RebateFormsService.new(rebate_form_fields_params).update!
    @rebate_form.update(updated_by: current_user.id)
    respond_with @rebate_form, location: admin_rebate_form_url(@rebate_form), notice: 'Rebate form was successfully updated.'
  end

  # DELETE /admin/rebate_forms/1
  def destroy
    if @rebate_form.completed
      redirect_to admin_rebate_forms_url, notice: 'Cannot delete signed forms.'
    else
      @rebate_form.destroy
      redirect_to admin_rebate_forms_url, notice: 'Rebate form was deleted.'
    end
  end

  private

  def set_rebate_form
    @rebate_form = RebateForm.find(params[:id])
    authorize @rebate_form
  end

  def rebate_form_fields_params
    params.permit(:id, :valuation_id, :total_rates, :location, :council, rebate_form: { fields: {} })
  end

  def rebate_form_params
    params.require(:rebate_form).permit(attachments: [])
  end

  def pdf_filename
    "#{@rebate_form.council.short_name}-(#{@rebate_form.valuation_id})-#{@rebate_form.id}"
  end
end
