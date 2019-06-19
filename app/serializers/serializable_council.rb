# frozen_string_literal: true

# Serializers define the rendered JSON for a model instance.
# We use jsonapi-rb, which is similar to active_model_serializers.
class SerializableCouncil < JSONAPI::Serializable::Resource
  type :councils

  # Add attributes here to ensure they get rendered, .e.g.
  #
  attribute :name
  attribute :short_name
  attribute :active
  attribute :has_address_lookups
  #
  # To customize, pass a block and reference the underlying @object
  # being serialized:
  #
  # attribute :name do
  #   @object.name.upcase
  # end
end
