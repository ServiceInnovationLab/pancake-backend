# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsService do
  let!(:property) { FactoryBot.create(:property_with_rates) }

  pending 'new rebate form' do
    let(:create_params) do
      {
        'total_rates' => '12345',
        'location' => property.location,
        'council' => property.council.name,
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
    let!(:property2) { FactoryBot.create(:property_with_rates) }
    let!(:rebate_form) { FactoryBot.create(:rebate_form, valuation_id: property.valuation_id, property: property) }
    let(:update_params) do
      {
        'id' => rebate_form.id,
        'valuation_id' => property2.valuation_id,
        'total_rates' => '12345',
        'location' => property2.location,
        'council' => property2.council.name,
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
          expect(RebateForm.first.reload.property.council.name).to eq property2.council.name
        end

        context 'without a valuation id' do
          let(:update_params) do
            {
              'id' => rebate_form.id,
              'total_rates' => '12345',
              'location' => property2.location,
              'council' => property2.council.name,
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

          it 'finds the correct property and updates the rebate form accordingly' do
            expect(RebateForm.first.property).to eq property
            subject.update
            expect(RebateForm.first.reload.property).to eq property2
          end
        end
      end
    end
  end
end
