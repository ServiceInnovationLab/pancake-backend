# frozen_string_literal: true

required_environment_variables = %w[
  YEAR
  OPENFISCA_ORIGIN
  HMAC_SECRET
  APP_URL
  IPAD_JWT_LENGTH
]

Dotenv.require_keys(required_environment_variables)
