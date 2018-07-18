# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { FactoryBot.create :admin_user }

  context 'signed in as admin' do
    let!(:user) { FactoryBot.create :user }
    before { sign_in admin_user }
    describe 'GET #index' do
      it 'assigns all users as @users' do
        get :index
        expect(assigns(:users)).to include(user)
        expect(assigns(:users)).to include(admin_user)
      end
    end

    describe 'GET #show' do
      it 'assigns the requested user as @user' do
        get :show, params: { id: user.to_param }
        expect(assigns(:user)).to eq(user)
      end
    end

    describe 'DELETE #destroy' do
      it 'Deativates the requested user' do
        expect do
          delete :destroy, params: { id: user.to_param }
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the users list' do
        delete :destroy, params: { id: user.to_param }
        expect(response).to redirect_to(admin_users_url)
      end
    end
  end
end
