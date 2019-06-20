class AddTotalRatesLocationToRebateForm < ActiveRecord::Migration[5.2]
  def up
    add_column :rebate_forms, :location, :string
    add_column :rebate_forms, :total_rates, :decimal, precision: 8, scale: 2
    update_existing_rebate_forms_up
  end

  def down
    update_existing_rebate_forms_down
    remove_column :rebate_forms, :location, :string
    remove_column :rebate_forms, :total_rates, :decimal, precision: 8, scale: 2
  end

  private

  def update_existing_rebate_forms_up
    RebateForm.all.each do |rebate_form|
      property = rebate_form.property
      rebate_form.update(location: property.location,
                         total_rates: property.rates_bills[0].total_rates,
                         valuation_id: rebate_form.fields['valuation_id'] || property.valuation_id || nil)
    end
  end

  def update_existing_rebate_forms_down
    RebateForm.all.each do |rebate_form|
      @rebate_form = rebate_form
      property = update_property!
      create_or_update_rates_bill!(property)
    end
  end

  def update_property!
    property = @rebate_form.property

    property.update!(location: @rebate_form.location,
                     valuation_id: @rebate_form.valuation_id)
    property
  end

  def create_or_update_rates_bill!(property)
    rates_bill = RatesBill.find_or_create_by(property: property,
                                             rating_year: property.rating_year)
    rates_bill.update!(total_rates: total_rates)
    rates_bill
  end

  def total_rates
    @rebate_form.total_rates || 0
  end
end
