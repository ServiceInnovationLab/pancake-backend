
require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RebateFormsHelper. For example:
#
# describe RebateFormsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

RSpec.describe RebateFormsHelper, type: :helper do
  let(:rebate_form) { FactoryBot.create :rebate_form }

  describe 'rebate_form_pdf_dependants(rebate_form)' do
    it { expect(rebate_form_pdf_dependants(rebate_form)).to eq 'no' }
  end

  describe 'rebate_form_pdf_home_business(rebate_form)' do
    it { expect(rebate_form_pdf_home_business(rebate_form)).to eq 'no' }
  end

  describe 'rebate_form_amount(rebate_form)' do
    it { expect(rebate_form_amount(rebate_form)).to eq '$555.12' }
  end

  describe 'rebate_form_total(rebate_form)' do
    it { expect(rebate_form_total(rebate_form)).to eq '$0.00' }
  end
end
