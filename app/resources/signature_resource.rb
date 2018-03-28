# frozen_string_literal: true

# Define how to query and persist a given model.
# Further Resource documentation: https://jsonapi-suite.github.io/jsonapi_compliable/JsonapiCompliable/Resource.html
class SignatureResource < ApplicationResource
  # Used for associating this resource with a given input.
  # This should match the 'type' in the corresponding serializer.
  type :signatures
  # Associate to a Model object so we know how to persist.
  model Signature
  # Customize your resource here. Some common examples:
  #
  # === Allow ?filter[name] query parameter ===
  # allow_filter :name
  #
  # === Enable total count, when requested ===
  # allow_stat total: [:count]
  #
  # === Allow sideloading/sideposting of relationships ===
  belongs_to :signature_type,
             foreign_key: :signature_type_id,
             resource: SignatureTypeResource,
             scope: -> { SignatureType.all }
  belongs_to :rebate_form,
             foreign_key: :rebate_form_id,
             resource: RebateFormResource,
             scope: -> { RebateForm.all }

  #
  # === Custom sorting logic ===
  # sort do |scope, att, dir|
  #   ... code ...
  # end
  #
  # === Change default sort ===
  # default_sort([{ title: :asc }])
  #
  # === Custom pagination logic ===
  # paginate do |scope, current_page, per_page|
  #   ... code ...
  # end
  #
  # === Change default page size ===
  # default_page_size(10)
  #
  # === Change how we resolve the scope ===
  # def resolve(scope)
  #   ... code ...
  # end
end
