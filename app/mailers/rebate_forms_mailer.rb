# frozen_string_literal: true

class RebateFormsMailer < ApplicationMailer
  def applicant_mail(rebate_form)
    @rebate_form = rebate_form
    @council = @rebate_form.council
    applicant_email = @rebate_form.email
    subject = 'Your Rates Rebate application'
    mail(to: applicant_email, subject: subject)
  end
end
