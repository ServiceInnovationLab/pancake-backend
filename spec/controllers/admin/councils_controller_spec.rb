# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CouncilsController, type: :controller do
  let!(:council) { FactoryBot.create :council }

  context 'Not signed in' do
    it 'GET #index' do
      get :index, params: {}
      expect(assigns(:councils)).to eq(nil)
      expect(response.status).to eq(302)
    end
  end

  context 'signed in as admin' do
    let(:admin_user) { FactoryBot.create :admin_user }
    before { sign_in admin_user }

    let(:valid_attributes) do
      { name: 'Tauranga', active: true }
    end

    let(:invalid_attributes) do
      { name: '', active: true }
    end

    describe 'GET #index' do
      it 'assigns all councils as @councils' do
        get :index, params: {}
        expect(assigns(:councils)).to eq([council])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested council as @council' do
        get :show, params: { id: council.to_param }
        expect(assigns(:council)).to eq(council)
      end
    end

    describe 'GET #new' do
      it 'assigns a new council as @council' do
        get :new, params: {}
        expect(assigns(:council)).to be_a_new(Council)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested council as @council' do
        get :edit, params: { id: council.to_param }
        expect(assigns(:council)).to eq(council)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Council' do
          expect do
            post :create, params: { council: valid_attributes }
          end.to change(Council, :count).by(1)
        end

        it 'assigns a newly created council as @council' do
          post :create, params: { council: valid_attributes }
          expect(assigns(:council)).to be_a(Council)
          expect(assigns(:council)).to be_persisted
        end

        it 'redirects to the created council' do
          post :create, params: { council: valid_attributes }
          expect(response).to redirect_to(admin_councils_path)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved council as @council' do
          post :create, params: { council: invalid_attributes }
          expect(assigns(:council)).to be_a_new(Council)
        end

        it "re-renders the 'new' template" do
          post :create, params: { council: invalid_attributes }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { name: 'Hamilton', active: true }
        end

        it 'updates the requested council' do
          put :update, params: { id: council.to_param, council: new_attributes }
          council.reload
          expect(council.name).to eq('Hamilton')
          expect(council.active).to eq true
        end

        it 'assigns the requested council as @council' do
          put :update, params: { id: council.to_param, council: valid_attributes }
          expect(assigns(:council)).to eq(council)
        end

        it 'redirects to the council' do
          put :update, params: { id: council.to_param, council: valid_attributes }
          expect(response).to redirect_to(admin_councils_path)
        end
      end

      context 'with invalid params' do
        it 'assigns the council as @council' do
          put :update, params: { id: council.to_param, council: invalid_attributes }
          expect(assigns(:council)).to eq(council)
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: council.to_param, council: invalid_attributes }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested council' do
        expect do
          delete :destroy, params: { id: council.to_param }
        end.to change(Council, :count).by(-1)
      end

      it 'redirects to the councils list' do
        delete :destroy, params: { id: council.to_param }
        expect(response).to redirect_to(admin_councils_url)
      end
    end
  end
end
