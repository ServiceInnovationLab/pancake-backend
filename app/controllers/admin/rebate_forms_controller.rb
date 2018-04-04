# frozen_string_literal: true

class Admin::RebateFormsController < ApplicationController
  before_action :set_admin_rebate_form, only: %i[show edit update destroy]

  # GET /admin/rebate_forms
  def index
    @rebate_forms = RebateForm.all
  end

  # GET /admin/rebate_forms/1
  def show; end

  # GET /admin/rebate_forms/new
  def new
    @rebate_form = RebateForm.new
  end

  # GET /admin/rebate_forms/1/edit
  def edit; end

  # POST /admin/rebate_forms
  def create
    @rebate_form = RebateForm.new(admin_rebate_form_params)

    if @rebate_form.save
      redirect_to @rebate_form, notice: 'Rebate form was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/rebate_forms/1
  def update
    if @rebate_form.update(admin_rebate_form_params)
      redirect_to @rebate_form, notice: 'Rebate form was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/rebate_forms/1
  def destroy
    @rebate_form.destroy
    redirect_to admin_rebate_forms_url, notice: 'Rebate form was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_rebate_form
    @rebate_form = RebateForm.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def admin_rebate_form_params
    params.fetch(:admin_rebate_form, {})
  end
end
