# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  describe '#index' do
    subject { JSON.parse(response.body)['data'] }

    let(:council) { FactoryBot.create :council }

    # Property to not find, address doesn't match
    let!(:property_1) do
      FactoryBot.create :property, location: '11 MAIN ROAD', council: council, rating_year: ENV['YEAR']
    end
    # Property we hope to find
    let!(:property_2) do
      FactoryBot.create :property, location: '11 MOANA ROAD', council: council, rating_year: ENV['YEAR']
    end
    # Property we should not find, it's for a different year
    let!(:property_3) { FactoryBot.create :property, location: '11 MOANA ROAD', council: council, rating_year: '1840' }

    shared_examples 'finds property' do
      before {
        get :index, format: :json, params: { q: query,
                                            council_id: council.id }
      }

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
    subject { JSON.parse(response.body)['data'] }

    let!(:property_1) do
      FactoryBot.create :property, location: '123 Lambton Quay',
                                   suburb: 'Te Aro', town_city: 'Poneke', rating_year: ENV['YEAR']
    end

    before { get :show, format: :json, params: { id: property_1.valuation_id } }

    it do
      is_expected.to eq(
        'id' => property_1.valuation_id,
        'type' => 'properties',
        'attributes' => {
          'valuation_id' => property_1.valuation_id,
          'location' => '123 Lambton Quay',
          'suburb' => 'Te Aro',
          'town_city' => 'Poneke',
          'rating_year' => ENV['YEAR'],
          'council_id' => property_1.council.id,
        },
        'relationships' => { 'rates_payers' => { 'data' => [] },
                            'rates_bills' => { 'data' => [] } },
      )
    end
  end
end
