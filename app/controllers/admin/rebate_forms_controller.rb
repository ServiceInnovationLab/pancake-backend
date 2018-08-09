# frozen_string_literal: true

class Admin::RebateFormsController < Admin::BaseController
  before_action :set_rebate_form, only: %i[show update destroy edit]
  respond_to :html, :pdf, :csv

  # GET /admin/rebate_forms
  def index
    @location = params[:location]
    @rating_year = params[:rating_year]
    @years = %w[2019 2018]
    @council = current_user.council.presence
    @rebate_forms = policy_scope(RebateForm).joins(:property)
                                            .includes(:signatures, :property)
                                            .order(created_at: :desc)

    # if user is searching location, do a couple more filters
    @rebate_forms = @rebate_forms.where('properties.location ILIKE ?', "%#{params[:location]}%") if @location.present?
    @rebate_forms = @rebate_forms.where("properties.rating_year": @rating_year) if @rating_year.present?
    respond_with @rebate_forms
  end

  # GET /admin/rebate_forms/1
  def show
    @year = ENV['YEAR']

    @rates_bill = @rebate_form.property.rates_bills.find_by(rating_year: @year)

    @signatures = {}
    SignatureType.order(:name).all.each do |st|
      @signatures[st.name] = @rebate_form.signatures.where(signature_type: st).order(created_at: :desc).first
    end

    respond_with(@rebate_form) do |format|
      format.pdf do
        render pdf: pdf_filename, page_size: 'A4', layout: 'pdf'
      end
    end
  end

  def edit
  end

  # PATCH/PUT /admin/rebate_forms/1
  def update
    # updating attachments
    if params.fetch(:rebate_form, {}).fetch(:attachments, false)
      @rebate_form.update(rebate_form_params)
    # updating rebate form itself
    elsif params.fetch(:rebate_form, false)
      # update the fields (preserves the other elements of the hash)
      @rebate_form.fields.update(rebate_form_fields_params) && @rebate_form.save
      @rebate_form.calc_rebate_amount!
    end
    respond_with @rebate_form, location: admin_rebate_form_url(@rebate_form), notice: 'Rebate form was successfully updated.'
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

  def set_rebate_form
    @rebate_form = RebateForm.find(params[:id])
    authorize @rebate_form
  end

  def rebate_form_fields_params
    params.require(:rebate_form).permit(
      fields: %i[:full_name, :income, :dependants, :lived_here_before_july_2017, :lived_here_before_july_2018])['fields']
  end

  def rebate_form_params
    params.require(:rebate_form).permit(attachments: [])
  end

  def pdf_filename
    "rebate-#{@rebate_form.council.short_name}-#{@rebate_form.id}"
  end
end
