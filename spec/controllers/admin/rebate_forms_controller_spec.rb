# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RebateFormsController, type: :controller do
  let(:property) { FactoryBot.create :property }
  let(:rebate_form) { FactoryBot.create :rebate_form, valuation_id: property.valuation_id }

  shared_examples 'can wrangle rebate_forms' do
    describe 'GET #index' do
      before { get :index, params: {} }

      describe 'assigns all rebate_forms as @rebate_forms' do
        it { expect(assigns(:rebate_forms)).to eq([rebate_form]) }
      end
    end

    describe 'GET #show' do
      context 'html' do
        before { get :show, params: { id: rebate_form.to_param } }

        describe 'assigns the requested rebate_form as @rebate_form' do
          it { expect(assigns(:rebate_form)).to eq(rebate_form) }
        end
      end
      context 'pdf' do
        before { get :show, params: { id: rebate_form.to_param }, format: :pdf }

        it { expect(assigns(:rebate_form)).to eq(rebate_form) }
      end

      describe 'PUT #update' do
        let(:property) { FactoryBot.create :property_with_rates, rating_year: '2019' }
        let(:rebate_form) do
          FactoryBot.create(:rebate_form,
                            rebate: 10,
                            property: property,
                            fields: {
                              valuation_id: '06601*004*02*',
                              rates_bill: 1.10,
                              dependants: 3,
                              income_range: 'below',
                              lived_here_before_july_2018: 'yes',
                              full_name: 'Sylvestor',
                              email: 'test@gmail.com',
                              phone_number: '5556789',
                              has_home_business: 'no',
                              email_phone_can_be_used: true,
                              income: 23_405.2,
                              lived_with_partner: false
                            })
        end

        before do
          put :update, params: { id: rebate_form.to_param, rebate_form: {
            fields: { full_name: 'Mary Jane Kelly', 'dependants': 9, income: 11_999 }
          } }
          rebate_form.reload
        end

        it { expect(assigns(:rebate_form)).to eq(rebate_form) }
        describe 'Does not have errors to report' do
          it { expect(assigns(:rebate_form).errors.empty?).to eq true }
          # it { expect(assigns(:rebate_form).errors).to eq [] }
          it { expect(assigns(:rebate_form)).to be_valid }
        end

        it 'recalculates rebate amount' do
          expect(rebate_form.rebate).to eq 630
        end

        it 'should update updated_by column with current user' do
          expect(rebate_form.updated_by).to eq(user.id)
        end

        subject { rebate_form.fields }

        describe 'should update full_name, dependants and income' do
          it { expect(subject['full_name']).to eq('Mary Jane Kelly') }
          it { expect(subject['dependants']).to eq('9') }
          it { expect(subject['income']).to eq('11999') }
        end

        describe 'preserves the existing fields' do
          it { expect(subject['email']).to eq 'test@gmail.com' }
          it { expect(subject['phone_number']).to eq '5556789' }
          it { expect(subject['has_home_business']).to eq 'no' }
          it { expect(subject['email_phone_can_be_used']).to eq true }
          it { expect(subject['lived_with_partner']).to eq false }
        end
      end
    end

    describe 'Editing rebate_forms' do
      let(:attachment_params) do
        { attachments: [
          tempfile: Rails.root.join('sig.png'),
          original_filename: 'sig.png',
          content_type: 'image/jpeg'
        ] }
      end
      shared_examples 'controller works' do
        it { expect(assigns(:rebate_form)).to eq(rebate_form) }
        it { expect(response).to redirect_to(admin_rebate_form_url(rebate_form)) }
      end

      context 'with valid params' do
        before { put :update, params: { id: rebate_form.to_param, rebate_form: attachment_params } }

        include_examples 'controller works'
      end

      context 'with invalid params' do
        let(:invalid_attributes) { { fields: {} } }

        before { put :update, params: { id: rebate_form.to_param, rebate_form: invalid_attributes } }

        include_examples 'controller works'
      end

      context 'rebate_form is completed' do
        let(:rebate_form) { FactoryBot.create :signed_form }

        it 'does not allow changes to completed rebate_form' do
          rebate_form
          expect do
            put :update, params: { id: rebate_form.to_param, rebate_form: attachment_params }
            rebate_form.reload
          end.not_to change(rebate_form, :valuation_id)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested rebate_form' do
        rebate_form
        expect do
          delete :destroy, params: { id: rebate_form.to_param }
        end.to change(RebateForm, :count).by(-1)
      end

      describe 'redirects to the rebate_forms list' do
        before { delete :destroy, params: { id: rebate_form.to_param } }

        it { expect(response).to redirect_to(admin_rebate_forms_url) }
      end
    end
  end

  context 'signed in as council users' do
    let(:user) { FactoryBot.create :user, council: rebate_form.council }
    before { sign_in user }
    include_examples 'can wrangle rebate_forms'
  end

  context 'signed in as admin' do
    let(:user) { FactoryBot.create :admin_user }
    before { sign_in user }
    include_examples 'can wrangle rebate_forms'
  end
end
