# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  #default from: 'noreply@dia.govt.nz'
  default from: 'info@digital.govt.nz'
  layout 'mailer'
end
