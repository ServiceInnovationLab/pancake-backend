# frozen_string_literal: true

class RebateFormsMailer < ApplicationMailer
  def council_mail
    @rebate_form = params[:rebate_form]
    council_mail = @rebate_form.council.email
    subject = "Rates rebate application for #{@rebate_form.property.location}"
    mail(to: council_mail, subject: subject)
  end

  def applicant_mail
    @rebate_form = params[:rebate_form]
    @council = @rebate_form.council
    applicant_email = @rebate_form.email
    subject = 'Your Rates Rebate application'
    mail(to: applicant_email, subject: subject)
  end
end
