# frozen_string_literal: true

# Serializers define the rendered JSON for a model instance.
# We use jsonapi-rb, which is similar to active_model_serializers.
class SerializableRatesPayer < JSONAPI::Serializable::Resource
  type :rates_payers

  # Add attributes here to ensure they get rendered, .e.g.
  #
  # attribute :name
  attributes :surname, :first_names
  #
  # To customize, pass a block and reference the underlying @object
  # being serialized:
  #
  # attribute :name do
  #   @object.name.upcase
  # end
end
