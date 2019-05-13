# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsService do
  pending 'new rebate form' do
    # these will not pass until the calulator is working
    let(:create_params) do
      {
        'valuation_id': '12345',
        'total_rates': '12345',
        'location': 'This is the address',
        'fields': {
          'full_name': 'Herminone Granger',
          'customer_id': '12345',
          'phone': '022123-4567',
          'email': 'hermione.granger@hogwarts.com',
          'partner': 'string string string',
          'dependants': '0',
          'occupation': 'witch',
          '50_percent_claimed': 'true',
          'moved_within_rating_year': 'false',
          'lived_in_property_july_1': 'true',
          'details_of_previous_property': 'string string string',
          'income': {}
        }
      }
    end

    subject { described_class.new(create_params) }

    describe '#update' do
      context 'with valid params' do
        it 'creates a new rebate form' do
          subject.update
          expect(RebateForm.count).to eq 1
        end
      end
    end
  end

  describe 'existing rebate form' do
    let!(:property) { FactoryBot.create(:property_with_rates) }
    let!(:property2) { FactoryBot.create(:property_with_rates) }
    let!(:rebate_form) { FactoryBot.create(:rebate_form, valuation_id: property.valuation_id, property: property) }
    let(:update_params) do
      {
        'id' => rebate_form.id,
        'valuation_id' => property2.valuation_id,
        'total_rates' => '12345',
        'location' => property2.location,
        'rebate_form' => {
          'fields' => {
            'full_name' => 'Best Witch',
            'customer_id' => '12345',
            'phone' => '022123-4567',
            'email' => 'hermione.granger@potterworld.com',
            'has_partner' => 'true',
            'dependants' => '3',
            'occupation' => 'witch',
            '50_percent_claimed' => 'true',
            'income' => {}
          }
        }
      }
    end

    subject { described_class.new(update_params) }

    describe '#update' do
      context 'with valid params' do
        it 'updates a rebate form' do
          subject.update
          expect(RebateForm.first.reload.fields['full_name']).to eq 'Best Witch'
          expect(RebateForm.first.reload.fields['email']).to eq 'hermione.granger@potterworld.com'
          expect(RebateForm.first.reload.fields['dependants']).to eq '3'
        end
      end
    end
  end
end
