# frozen_string_literal: true

class GenerateQrService
  def initialize(rebate_form, current_user)
    @rebate_form = rebate_form
    @current_user = current_user
  end

  def generate_qr
    # create a new token that only allows you to fetch a restricted set of details for this application only
    # and use the same token to submit the signatures back
    # this token duration is configured by ENV['IPAD_JWT_LENGTH']

    token = JwtService.new.encode(
      rebate_form.id,
      witness: witness_details(@current_user)
    )

    # iPad-application URL
    url = ENV['APP_URL'] + 'ipad/?t=' + token
    Rails.logger.info('the ipad signing url is:' + url) # for easier debugging in production
    qr_code(url)
  end

  private

  def witness_details(current_user)
    {
      name: current_user&.name || '',
      location: current_user&.council&.name,
      occupation: 'Authorised Council Officer'
    }
  end

  def qr_code(url)
    RQRCode::QRCode
      .new(url, size: 20, level: :h)
      .as_png(offset: 0, color: '0', shape_rendering: 'crispEdges', module_size: 10)
      .to_data_url
  end
end
