# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@www.govt.nz '
  layout 'mailer'
end
