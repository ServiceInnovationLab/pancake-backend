# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let(:user) { FactoryBot.create(:admin_user, council: property.council) }
  let!(:batched_form) { FactoryBot.create :batched_form, property: property }

  context 'can see the pdf' do
    before { login_as(user, scope: :user) }

    it 'displays the correct content' do
      visit "/admin/batches/#{batched_form.batch_id}.pdf"
      convert_pdf_to_page
      expect(page).to have_content "COVER PAGE for Batch #{batched_form.batch_id}"
    end
  end

  private

  def convert_pdf_to_page
    temp_pdf = Tempfile.new('pdf')
    temp_pdf << page.source.force_encoding('UTF-8')
    reader = PDF::Reader.new(temp_pdf)
    pdf_text = reader.pages.map(&:text)
    temp_pdf.close
    page.driver.response.instance_variable_set('@body', pdf_text)
  end
end
