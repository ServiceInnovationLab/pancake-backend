# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignaturesController, type: :controller do
  subject { JSON.parse(response.body)['data'] }

  let(:witness) { FactoryBot.create(:user) }
  let(:rebate_form) { FactoryBot.create :rebate_form }
  let(:token) { JwtService.new.create_signing_token(rebate_form.id, witness: witness) }
  let!(:signature_type) { FactoryBot.create :signature_type, name: 'applicant' }

  before do
    Timecop.freeze(Time.now.utc - 1.day) do
      rebate_form
    end

    Timecop.freeze(Time.now.utc - 1.minute) do
      token
    end
  end

  describe '#create' do
    let(:body) do
      {
        "data": {
          "type": 'signatures',
          "token": token,
          "signatures": [{
            "type": signature_type.name,
            "name": 'brenda',
            "role": 'pancake eater',
            "image": Base64.encode64(File.open('sig.png', 'rb').read)
          }]
        }
      }
    end

    context 'the token is not stale' do
      before do
        post :create, format: :json, params: body
      end

      it { expect(subject.first['attributes']['name']).to eq 'brenda' }
      it { expect(subject.first['attributes']['role']).to eq 'pancake eater' }
      it { expect(Signature.first.name).to eq 'brenda' }
      it { expect(Signature.first.role).to eq 'pancake eater' }
    end

    context 'the token is stale' do
      before do
        rebate_form.update!(updated_at: Time.now.utc)
        post :create, format: :json, params: body
      end

      it { expect(response).to have_http_status(:conflict) }
    end
  end
end
