# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateQrService do
  let!(:current_user) { FactoryBot.create(:admin_user) }
  let!(:rebate_form) { FactoryBot.create(:rebate_form) }

  subject { described_class.new(rebate_form, current_user) }

  describe '#generate_qr' do
    it 'generates a qr code' do
      expect(subject.generate_qr).to start_with 'data:image/png;base64'
    end
  end
end
