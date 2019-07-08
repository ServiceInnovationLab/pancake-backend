# frozen_string_literal: true

# A wrapper around the jwt gem.
#
# The algorithm is hard coded for security, as reccommended by the gem documentation
class JwtService
  def initialize
    @hmac_secret = ENV['HMAC_SECRET']
    @hmac_algorithm = 'HS256'
    @verify_on_decode = true
    @default_duration = ENV['IPAD_JWT_LENGTH'].to_i * 60
  end

  # Validate the JWT Token and get the RebateForm it permits signing of
  def decode_for_rebate_form_signing(token)
    # the first part of the token is the payload, the second is the algorithm
    decoded_token = decode(token).first

    raise JsonapiCompliable::Errors::RecordNotFound unless decoded_token['per'] == 'sign'

    RebateForm.find(decoded_token['rebate_form_id'])
  end

  # Create a JWT permitted for signing a rebate form
  def encode_for_rebate_form_signing(rebate_form_id, witness:, expire_at: default_expiry)
    encode(
      rebate_form_id: rebate_form_id,
      exp: expire_at,
      per: 'sign',
      witness: witness
    )
  end

  private

  def encode(payload)
    JWT.encode payload, @hmac_secret, @hmac_algorithm
  end

  def decode(token)
    JWT.decode token, @hmac_secret, @verify_on_decode, algorithm: @hmac_algorithm
  end

  def default_expiry
    Time.now.to_i + @default_duration
  end
end
