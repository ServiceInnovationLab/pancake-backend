# frozen_string_literal: true

class RebateFormsMailer < ApplicationMailer
  def council_mail
    @rebate_form = params[:rebate_form]
    council_mail = @rebate_form.council.email
    subject = @rebate_form.fields['what_is_your_address']
    mail(to: council_mail, subject: subject)
  end

  def applicant_mail
    @rebate_form = params[:rebate_form]
    applicant_email = @rebate_form.fields['email']
    mail(to: applicant_email, subject: 'New Rates Rebate application')
  end
end
