class AddTotalRatesLocationToRebateForm < ActiveRecord::Migration[5.2]
  def up
    add_column :rebate_forms, :location, :string
    add_column :rebate_forms, :total_rates, :decimal, precision: 8, scale: 2
    update_existing_rebate_forms_up
  end

  def down
    remove_column :rebate_forms, :location, :string
    remove_column :rebate_forms, :total_rates, :decimal, precision: 8, scale: 2
  end

  private

  def update_existing_rebate_forms_up
    RebateForm.all.each do |rebate_form|
      property = rebate_form.property
      rebate_form.update(location: property.location,
                         total_rates: property.rates_bills[0]&.total_rates,
                         valuation_id: rebate_form.fields['valuation_id'] || property.valuation_id || nil)
    end
  end
end
