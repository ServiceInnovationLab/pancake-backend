# frozen_string_literal: true

# Serializers define the rendered JSON for a model instance.
# We use jsonapi-rb, which is similar to active_model_serializers.
class SerializableRatesBill < JSONAPI::Serializable::Resource
  type :rates_bills

  # Add attributes here to ensure they get rendered, .e.g.
  #
  # attribute :name
  attributes :rating_year, :total_bill, :rating_year

  #
  # To customize, pass a block and reference the underlying @object
  # being serialized:
  #
  # attribute :name do
  #   @object.name.upcase
  # end
end
