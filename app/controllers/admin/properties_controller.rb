# frozen_string_literal: true

class Admin::PropertiesController < Admin::BaseController
  before_action :set_property, only: %i[show edit update destroy]

  def index
    @properties = policy_scope(Property).page(params[:page])
  end

  def show; end

  def new
    @property = Property.new
  end

  def edit; end

  def create
    @property = Property.new(property_params)

    if @property.save
      redirect_to @property, notice: 'Property was successfully created.'
    else
      render :new
    end
  end

  def update
    if @property.update(property_params)
      redirect_to admin_property_path(@property), notice: 'Property was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @property.destroy
    redirect_to admin_properties_url, notice: 'Property was successfully destroyed.'
  end

  private

  def set_property
    @property = Property.find(params[:id])
    authorize @property
  end

  def property_params
    params.require(:property).permit(:location, :suburb, :town_city)
  end
end
