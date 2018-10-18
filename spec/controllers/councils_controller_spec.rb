# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CouncilsController, type: :controller do

  describe '#index' do
    subject { JSON.parse(response.body)['data'] }
    let!(:council) { FactoryBot.create(:council)}
    before { get :index, format: :json }
    it {expect(subject.size).to eq 1}
    it {expect(subject.first['id']).to eq council.id.to_s}
  end

  describe '#show' do
    let!(:council) { FactoryBot.create(:council)}
    subject { JSON.parse(response.body)['data'] }
    before { get :show, format: :json, params: {id: council.short_name} }
    it do
      is_expected.to eq(
         "id"=> council.id.to_s,
         "type"=> "councils",
         "attributes"=>{"name"=>council.name, "short_name"=>council.short_name, "active"=>council.active}
      )
    end

    it "raise not found error if id does not match" do
      expect { get :show, format: :json, params: {id: 0}}.to raise_error(JsonapiCompliable::Errors::RecordNotFound)
    end
  end

end
