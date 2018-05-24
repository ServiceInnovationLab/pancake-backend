# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  describe '#index' do
    let!(:property_1) { FactoryBot.create :property, location: '11 MAIN ROAD' }
    let!(:property_2) { FactoryBot.create :property, location: '11 MOANA ROAD' }

    subject { JSON.parse(response.body)['data'] }

    shared_examples 'finds property' do
      before { get :index, format: :json, params: { q: query } }
      it { expect(subject.size).to eq 1 }
      it { expect(subject.first['id']).to eq property_2.valuation_id }
    end

    describe 'name search' do
      let(:query) { 'moana' }
      include_examples 'finds property'
    end

    describe 'name search' do
      let(:query) { 'moana road' }
      include_examples 'finds property'
    end

    describe 'name search' do
      let(:query) { '1 moana road' }
      include_examples 'finds property'
    end
  end

  describe '#show' do
    let!(:property_1) do
      FactoryBot.create :property, location: '123 Lambton Quay', suburb: 'Te Aro', town_city: 'Poneke'
    end
    subject { JSON.parse(response.body)['data'] }

    before { get :show, format: :json, params: { id: property_1.valuation_id } }

    it do
      is_expected.to eq(
        'id' => property_1.valuation_id,
        'type' => 'properties',
        'attributes' =>
          { 
            'valuation_id' => property_1.valuation_id,
            'location' => '123 Lambton Quay',
            'suburb' => 'Te Aro',
            'town_city' => 'Poneke' 
          },
        'relationships' => { 'rates_payers' => { 'data' => [] }, 'rates_bills' => { 'data' => [] } }
      )
    end
  end
end
