# frozen_string_literal: true

FactoryBot.define do
  factory :signature do
    signature_type
    rebate_form
    image { Base64.encode64(File.open('sig.png', 'rb').read) }
    name { Faker::Name.name_with_middle }
    role { 'Authorised Council Officer' }
  end
  factory :applicant_signature, parent: :signature do
    signature_type { SignatureType.find_or_create_by(name: 'applicant') }
  end
  factory :witness_signature, parent: :signature do
    signature_type { SignatureType.find_or_create_by(name: 'witness') }
  end
end
