# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Admin::UsersHelper. For example:
#
# describe Admin::UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Admin::SignaturesHelper, type: :helper do
  let(:signature) { FactoryBot.create :signature }
  describe "signature_image_path(signature)" do
    let(:valuation_id) { signature.rebate_form.valuation_id }
    let(:token) { signature.rebate_form.token }
    it { expect(signature_image_path(signature)).to eq "/admin/signature?token=#{token}&type=#{signature.signature_type.name}&valuation_id=#{valuation_id}"}
  end

  describe "signature_for_pdf(signature)" do
    it { expect(signature_for_pdf(signature)).to start_with '<img src="data:image/png;base64,'}
  end
end
