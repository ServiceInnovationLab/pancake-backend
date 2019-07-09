# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignaturesController, type: :controller do
  subject { JSON.parse(response.body)['data'] }

  let!(:rebate_form) { FactoryBot.create :rebate_form }
  let!(:signature_type) { FactoryBot.create :signature_type, name: 'applicant' }

  describe '#create' do
    let(:body) do
      {
        "data": {
          "type": 'signatures',
          "token": rebate_form.token,
          "signatures": [{
            "type": signature_type.name,
            "name": 'brenda',
            "role": 'pancake eater',
            "image": Base64.encode64(File.open('sig.png', 'rb').read)
          }]
        }
      }
    end

    let(:decode_token) do
      {
        rebate_form_id: rebate_form.id,
        exp: Time.now.to_i + ENV['IPAD_JWT_LENGTH'].to_i * 60 + 1,
        per: 'sign'
      }
    end

    before do
      allow(JWT).to receive(:decode).and_return([decode_token.stringify_keys])
      post :create, format: :json, params: body
    end

    it { expect(subject.first['attributes']['name']).to eq 'brenda' }
    it { expect(subject.first['attributes']['role']).to eq 'pancake eater' }
    it { expect(Signature.first.name).to eq 'brenda' }
    it { expect(Signature.first.role).to eq 'pancake eater' }
  end
end
