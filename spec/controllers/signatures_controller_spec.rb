# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignaturesController, type: :controller do
  subject { JSON.parse(response.body)['data']['attributes'] }

  let(:rebate_form) { FactoryBot.create :rebate_form }
  let(:signature_type) { FactoryBot.create :signature_type, name: 'applicant' }

  describe '#create' do
    let(:body) do
      {
        "data": {
          "type": 'signatures',
          "attributes": {
            "valuation_id": rebate_form.valuation_id,
            "token": rebate_form.token,
            "type": signature_type.name,
            "name": 'brenda',
            "role": 'pancake eater',
            "image": Base64.encode64(File.open('sig.png', 'rb').read),
          },
        },
      }
    end

    before { post :create, format: :json, params: body }

    it { expect(subject['name']).to eq 'brenda' }
    it { expect(subject['role']).to eq 'pancake eater' }
  end
end
