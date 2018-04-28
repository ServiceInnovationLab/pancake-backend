# frozen_string_literal: true

# Register a payload to validate against.
# Add expected attributes within this block, e.g.:
#
# key(:name)
#
# Optionally validate the type as well:
#
# key(:name, String)
#
# This will:
#
# * Compare record.name == json['name']
# * Ensure no extra keys are in the json payload
# * Ensure no values are nil (unless allow_nil: true is passed)
# * Ensures json['name'] is a string
#
# If you have custom serialization logic and want to compare against
# something other than "record.name", pass a block:
#
# key(:name) { |record| record.name.upcase }
#
# Or, if this is a one-off for a particular spec, do that customization at
# runtime:
#
# assert_payload(:person, person_record, json_item) do
#   key(:name) { 'Homer Simpson' }
# end
#
# For more information, see https://jsonapi-suite.github.io/jsonapi_spec_helpers/
JsonapiSpecHelpers::Payload.register(:rates_payer) do
end
