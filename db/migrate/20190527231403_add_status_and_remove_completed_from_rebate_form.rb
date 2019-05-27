class AddStatusAndRemoveCompletedFromRebateForm < ActiveRecord::Migration[5.2]
  def up
    add_column :rebate_forms, :status, :string, default: 'not signed'
    update_existing_rebate_forms_up
    remove_column :rebate_forms, :completed
  end

  def down
    add_column :rebate_forms, :completed, :boolean, default: false
    update_existing_rebate_forms_down
    remove_column :rebate_forms, :status
  end

  private

  def update_existing_rebate_forms_up
    RebateForm.all.each do |rebate_form|
      rebate_form.update(status: 'signed') if rebate_form.completed
      rebate_form.update(status: 'not signed') unless rebate_form.completed
    end
  end

  def update_existing_rebate_forms_down
    RebateForm.all.each do |rebate_form|
      rebate_form.update(completed: true) if rebate_form.status == 'signed'
      rebate_form.update(status: 'not signed') unless rebate_form.status == 'signed'
    end
  end
end
