# frozen_string_literal: true

FactoryBot.define do
  factory :signature do
    signature_type
    rebate_form
    image { File.open('sig.png', 'rb').read }
  end
  factory :applicant_signature, parent: :signature do
    signature_type { FactoryBot.create :signature_type, name: 'applicant' }
  end
  factory :witness_signature, parent: :signature do
    signature_type { FactoryBot.create :signature_type, name: 'witness' }
  end
end
