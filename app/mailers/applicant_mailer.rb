class ApplicantMailer < ApplicationMailer
  def form_email
    byebug
    @email = params[:email]
    mail(to: @email, subject: 'New ratesrebate application')
  end
end
