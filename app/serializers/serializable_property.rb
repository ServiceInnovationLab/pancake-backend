# frozen_string_literal: true

# Serializers define the rendered JSON for a model instance.
# We use jsonapi-rb, which is similar to active_model_serializers.
class SerializableProperty < JSONAPI::Serializable::Resource
  type :properties

  id { @object.valuation_id }
  # Add attributes here to ensure they get rendered, .e.g.
  attributes :valuation_id, :location, :suburb, :town_city

  has_many :rates_payers
  has_many :rates_bills

  #
  # attribute :name
  #
  # To customize, pass a block and reference the underlying @object
  # being serialized:
  #
  # attribute :name do
  #   @object.name.upcase
  # end
end
