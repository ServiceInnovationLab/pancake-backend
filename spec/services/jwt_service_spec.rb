# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtService do
  subject { described_class.new }
  let!(:current_user) { FactoryBot.create(:admin_user) }

  let(:rebate_form) { FactoryBot.create(:rebate_form) }

  before do
    # Rebate form must be created in the past to avoid a stale payload error
    Timecop.freeze(Time.now.utc - 1.day) do
      rebate_form
    end
  end

  context 'using the generic encode and decode functions' do
    let(:payload) do
      {
        rebate_form_id: rebate_form.id,
        exp: Time.now.to_i + ENV['IPAD_JWT_LENGTH'].to_i * 60,
        per: 'sign'
      }
    end

    it 'can encode and decode a payload' do
      token = subject.send(:encode, payload)

      expect(token.class).to be String

      result = subject.send(:decode, token)

      expect(result.first).to contain_exactly(*payload.stringify_keys)
      expect(result.second).to contain_exactly(%w[alg HS256])
    end
  end

  context 'using the rebate form signing functions' do
    context 'a user is provided as witness' do
      let(:witness) { FactoryBot.create(:user) }

      it 'can encode and decode a rebate form' do
        token = subject.create_signing_token(rebate_form.to_param, witness: witness)

        expect(token.class).to be String

        result = subject.decode_signing_token(token)

        expect(result).to eq(rebate_form)
      end
    end

    context 'the witness is nil' do
      let(:witness) { nil }

      it 'can encode and decode a rebate form' do
        token = subject.create_signing_token(rebate_form.to_param, witness: witness)

        expect(token.class).to be String

        result = subject.decode_signing_token(token)

        expect(result).to eq(rebate_form)
      end
    end
  end
end
