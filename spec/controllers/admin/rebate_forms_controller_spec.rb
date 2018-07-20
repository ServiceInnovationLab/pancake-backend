# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RebateFormsController, type: :controller do
  let(:rebate_form) { FactoryBot.create :rebate_form }
  context 'signed in as admin' do
    let(:admin_user) { FactoryBot.create :admin_user }
    before { sign_in admin_user }

    let(:valid_attributes) do
      FactoryBot.build(:rebate_form).attributes.symbolize_keys
    end

    let(:invalid_attributes) do
      {valuation_id: 1}
    end

    describe 'GET #index' do
      describe 'assigns all rebate_forms as @rebate_forms' do
        before { get :index, params: {} }
        it { expect(assigns(:rebate_forms)).to eq([rebate_form]) }
      end
    end

    describe 'GET #show' do
      describe 'assigns the requested rebate_form as @rebate_form' do
        before { get :show, params: { id: rebate_form.to_param } }
        it { expect(assigns(:rebate_form)).to eq(rebate_form) }
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.build(:rebate_form).attributes.symbolize_keys
        end

        it 'updates the requested rebate_form' do
          put :update, params: { id: rebate_form.to_param, rebate_form: new_attributes }
          rebate_form.reload
          expect(rebate_form.valuation_id).to eq(new_attributes[:valuation_id])
        end

        describe 'assigns the requested rebate_form as @rebate_form' do
          before { put :update, params: { id: rebate_form.to_param, rebate_form: valid_attributes } }
          it { expect(assigns(:rebate_form)).to eq(rebate_form) }
        end

        describe 'redirects to the rebate_form' do
          before { put :update, params: { id: rebate_form.to_param, rebate_form: valid_attributes } }
          it { expect(response).to redirect_to(admin_rebate_forms_url) }
        end
      end

      context 'with invalid params' do
        describe 'assigns the rebate_form as @rebate_form' do
          before { put :update, params: { id: rebate_form.to_param, rebate_form: invalid_attributes } }
          it { expect(assigns(:rebate_form)).to eq(rebate_form) }
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: rebate_form.to_param, rebate_form: invalid_attributes }
          expect(response).to render_template('edit')
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

      it 'redirects to the rebate_forms list' do
        delete :destroy, params: { id: rebate_form.to_param }
        expect(response).to redirect_to(admin_rebate_forms_url)
      end
    end
  end
end
