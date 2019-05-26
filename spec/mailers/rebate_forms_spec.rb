# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsMailer, type: :mailer do
  describe '#applicant_mail' do
    let(:rebate_form) { FactoryBot.create(:rebate_form) }
    let(:email) { RebateFormsMailer.applicant_mail(rebate_form) }

    it 'has the expected data' do
      expect(email.from).to eq(['info@digital.govt.nz'])
      expect(email.to).to eq([rebate_form.email])
      expect(email.subject).to eq('Your Rates Rebate application')

      text_body = email.body.to_s

      expect(text_body).to include "Hi #{rebate_form.fields['full_name']}"
      expect(text_body).to include 'Your application for a rates rebate'
      expect(text_body).to include "for the 1 July #{rebate_form.rating_year.to_i - 1}"
      expect(text_body).to include "– 30 June #{rebate_form.rating_year} rates year"
      expect(text_body).to include "has been sent to the #{rebate_form.council.name}."
      expect(text_body).to include 'What you need to do now'
      expect(text_body).to include "Go to the #{rebate_form.council.name}"
      expect(text_body).to include 'Tell the Service Centre staff you\'re there to sign your rates rebate application.'
      expect(text_body).to include 'Make sure you complete your application by getting your signature witnessed'
      expect(text_body).to include 'at the council offices as soon as you can.'
      expect(text_body).to include 'Please note: you can only apply for a rebate for'
      expect(text_body).to include "the #{rebate_form.rating_year.to_i - 1}/#{rebate_form.rating_year} rates year"
      expect(text_body).to include "1 July #{rebate_form.rating_year.to_i - 1} – 30 June #{rebate_form.rating_year}."
      expect(text_body).to include "If you have any issues, call the #{rebate_form.council.name}"
    end
  end
end
