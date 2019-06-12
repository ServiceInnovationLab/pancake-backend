# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsHelper, type: :helper do
  let(:rebate_form) { FactoryBot.create :rebate_form }

  describe 'rebate_form_boolean_field_to_english' do
    it { expect(rebate_form_boolean_field_to_english(true)).to eq 'Yes' }
    it { expect(rebate_form_boolean_field_to_english('yes')).to eq 'Yes' }
    it { expect(rebate_form_boolean_field_to_english('Yes')).to eq 'Yes' }

    it { expect(rebate_form_boolean_field_to_english(false)).to eq 'No' }
    it { expect(rebate_form_boolean_field_to_english('No')).to eq 'No' }

    it { expect(rebate_form_boolean_field_to_english('')).to eq 'No answer' }
    it { expect(rebate_form_boolean_field_to_english(nil)).to eq 'No answer' }

    it { expect(rebate_form_boolean_field_to_english('spaghetti')).to eq 'Spaghetti' }
  end

  describe 'rebate_form_pdf_dependants(rebate_form)' do
    it { expect(rebate_form_pdf_dependants(rebate_form)).to eq 'None' }
  end

  describe 'rebate_form_pdf_home_business(rebate_form)' do
    it { expect(rebate_form_pdf_home_business(rebate_form)).to eq 'no' }
  end

  describe 'rebate_form_amount(rebate_form)' do
    it { expect(rebate_form_amount(rebate_form)).to eq '$555.12' }
  end

  pending 'rebate_form_total(rebate_form)' do
    it { expect(rebate_form_total(rebate_form)).to eq '$0.00' }
  end

  describe 'rebate_form_lived_year?(rebate_form)' do
    let(:rebate_form) { FactoryBot.create :rebate_form, fields: fields }

    describe 'yes' do
      let(:fields) { { "full_name": 'Fred', "income": 0, dependants: 0, "lived_here_before_july_2019": 'yes' } }

      it { expect(rebate_form_lived_year?(rebate_form)).to eq 'Yes' }
    end

    describe 'no' do
      let(:fields) { { "full_name": 'Fred', "income": 0, dependants: 0, "lived_here_before_july_2019": 'no' } }

      it { expect(rebate_form_lived_year?(rebate_form)).to eq 'No' }
    end

    describe 'not answered' do
      let(:fields) { { "full_name": 'Fred', "income": 0, dependants: 0 } }

      it { expect(rebate_form_lived_year?(rebate_form)).to eq 'No answer' }
    end
  end

  describe 'rebate_form_year_header(rebate_form)' do
    it { expect(rebate_form_year_header(rebate_form)).to eq "#{rebate_form.rating_year.to_i - 1}/#{rebate_form.rating_year} Rates Rebate" }
  end
end
