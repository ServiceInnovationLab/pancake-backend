# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#create', type: :request do
  subject(:make_request) do
    post '/api/v1/signatures', params: payload
  end

  let!(:rebate_form) { FactoryBot.create :rebate_form }
  let!(:signature_type) { FactoryBot.create :signature_type, name: 'applicant' }

  describe 'basic create' do
    let(:payload) do
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
        exp: Time.now.to_i + (ENV['IPAD_JWT_LENGTH'].to_i * 60) + 1.day,
        per: 'sign'
      }
    end

    context 'creates the resource' do
      before do
        allow(JWT).to receive(:decode).and_return([decode_token.stringify_keys])
      end

      it 'works' do
        expect do
          make_request
        end.to change(Signature, :count).by(1)
      end
    end
  end
end
