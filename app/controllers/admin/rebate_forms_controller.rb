# frozen_string_literal: true

class Admin::RebateFormsController < Admin::BaseController
  before_action :set_rebate_form, only: %i[show update destroy decline undecline edit]
  respond_to :html, :pdf, :csv, :json

  def generateqr
    @rebate_form = RebateForm.find(params[:rebate_form_id])
    authorize @rebate_form

    @image_data = GenerateQrService.new(@rebate_form, current_user).generate_qr
  end

  def edit; end

  # GET /admin/rebate_forms
  def index
    @name = params[:name]

    @rebate_forms = policy_scope(RebateForm)
                    .where(status: RebateForm::NOT_SIGNED_STATUS)
                    .order(created_at: :asc)

    # filter by the search form fields
    @rebate_forms = @rebate_forms.where("fields ->> 'full_name' iLIKE ?", "%#{@name}%") if @name.present?

    respond_with json: @rebate_forms
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

    respond_with(@rebate_form)
  end

  # PATCH/PUT /admin/rebate_forms/1
  def update
    @rebate_form = RebateFormsUpdateService.new(rebate_form_fields_params).update!
    @rebate_form.update(updated_by: current_user.id)
    respond_with @rebate_form, location: admin_rebate_form_url(@rebate_form), notice: 'Rebate form was successfully updated.'
  end

  # DELETE /admin/rebate_forms/1
  def destroy
    if @rebate_form.signed_state?
      redirect_to admin_rebate_forms_url, notice: 'Cannot delete signed forms.'
    else
      @rebate_form.destroy
      redirect_to admin_rebate_forms_url, notice: 'Rebate form was deleted.'
    end
  end

  # POST /admin/rebate_forms/1/decline
  def decline
    @rebate_form.discard(comment: 'Because I want to')

    redirect_to admin_rebate_form_path(@rebate_form), notice: 'Rebate form was archived.'
  end

  # POST /admin/rebate_forms/1/undecline
  def undecline
    @rebate_form.undiscard(comment: 'Because I no longer want to')

    redirect_to admin_rebate_form_path(@rebate_form), notice: 'Rebate form was restored.'
  end

  private

  def set_rebate_form
    @rebate_form = RebateForm.find(params[:id] || params[:rebate_form_id])

    authorize @rebate_form
  end

  def rebate_form_fields_params
    params.permit(:id,
                  :total_rates,
                  :location,
                  :council,
                  fields: {})
  end

  def pdf_filename
    "#{@rebate_form.council.short_name}-(#{@rebate_form.valuation_id})-#{@rebate_form.id}"
  end
end
