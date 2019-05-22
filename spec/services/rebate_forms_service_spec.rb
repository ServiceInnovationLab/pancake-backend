# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsService do
  let!(:property) { FactoryBot.create(:property_with_rates) }

  describe 'new rebate form' do
    let(:create_params) do
      {
        'total_rates' => '12345',
        'location' => property.location,
        'council' => property.council.name,
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
    end

    subject { described_class.new(create_params) }

    describe '#update!' do
      context 'with valid params' do
        it 'creates a new rebate form' do
          subject.update!
          expect(RebateForm.count).to eq 1
          expect(RebateForm.first.fields['location']).to eq property.location
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

    describe '#update!' do
      context 'with invalid params' do
        let(:update_params) do
          {
            'id' => rebate_form.id,
            'valuation_id' => property2.valuation_id,
            'total_rates' => '12345',
            'location' => property2.location,
            'rebate_form' => {
              'fields' => {}
            }
          }
        end

        it 'raises an error' do
          expect { subject.update! }.to raise_error(RebateFormsService::Error)
        end
      end

      context 'with valid params' do
        it 'updates a rebate form' do
          subject.update!
          expect(RebateForm.first.fields['full_name']).to eq 'Best Witch'
          expect(RebateForm.first.fields['email']).to eq 'hermione.granger@potterworld.com'
          expect(RebateForm.first.fields['dependants']).to eq '3'
          expect(RebateForm.first.property.council.name).to eq property2.council.name
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
            subject.update!
            expect(RebateForm.first.property).to eq property2
          end
        end

        context 'when it receives an address that doesn\'t belong to an existing property' do
          let(:update_params) do
            {
              'id' => rebate_form.id,
              'total_rates' => '12345',
              'location' => 'This is a different address than property2',
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

          it 'creates a new property object' do
            expect(Property.count).to eq 2
            subject.update!
            expect(Property.count).to eq 3
            expect(Property.last.location).to eq 'This is a different address than property2'
          end
        end

        context 'when it receives an address that is slightly different than that of an existing property' do
          # property2 address is '999 Lambton quay'
          let(:update_params) do
            {
              'id' => rebate_form.id,
              'total_rates' => '12345',
              'location' => '999 Lambton Quay',
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

          it 'creates a new property object' do
            expect(Property.count).to eq 2
            subject.update!
            expect(Property.count).to eq 3
            expect(Property.last.location).to eq '999 Lambton Quay'
          end
        end

        context 'when the rebate form is already completed with signatures attached' do
          let!(:rebate_form) do
            FactoryBot.create(:signed_form, valuation_id: property.valuation_id, property: property, completed: true)
          end

          let(:update_params) do
            {
              'id' => rebate_form.id,
              'total_rates' => '12345',
              'location' => '999 Lambton Quay',
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

          it 'removes the signatures and sets completed to false' do
            expect(RebateForm.first.completed).to eq true
            expect(RebateForm.first.signatures).to_not be_empty
            subject.update!
            expect(RebateForm.first.completed).to eq false
            expect(RebateForm.first.signatures).to be_empty
          end
        end
      end
    end
  end
end
