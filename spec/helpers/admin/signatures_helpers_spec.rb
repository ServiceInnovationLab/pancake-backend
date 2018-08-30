# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SignaturesHelper, type: :helper do
  let(:signature) { FactoryBot.create :signature }

  describe 'signature_image_path(signature)' do
    let(:valuation_id) { signature.rebate_form.valuation_id }
    let(:token) { signature.rebate_form.token }

    it { expect(signature_image_path(signature)).to eq "/admin/signature?token=#{token}&type=#{signature.signature_type.name}&valuation_id=#{valuation_id}" }
  end

  describe 'signature_for_pdf(signature, type)' do
    it { expect(signature_for_pdf(signature,'applicant')).to start_with '<img class="applicant" src="data:image/png;base64,' }
  end
end
