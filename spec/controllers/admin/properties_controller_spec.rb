# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PropertiesController, type: :controller do
  let!(:council) { FactoryBot.create :council }
  let(:properties) { FactoryBot.create_list :property, 100, council: council }

  context 'Not signed in' do
    before { get :index, params: { council_id: council.id } }
    it 'GET #index' do
      expect(assigns(:council)).to eq(nil)
      expect(response.status).to eq(302)
    end
  end

  context 'signed in as admin' do
    let(:admin_user) { FactoryBot.create :admin_user }
    before { sign_in admin_user }

    describe 'GET #index' do
      before { get :index, params: { council_id: council.id } }
      it { expect(assigns(:council)).to eq(council) }
    end
  end

  context 'signed in as council' do
    let(:council_user) { FactoryBot.create :user, council: council }
    before { sign_in council_user }

    describe 'GET #index' do
      before { get :index, params: { council_id: council.id } }
      it { expect(assigns(:council)).to eq(council) }
    end
  end
end
