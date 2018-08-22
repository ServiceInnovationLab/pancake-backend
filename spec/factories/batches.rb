# frozen_string_literal: true

FactoryBot.define do
  factory :batch do
    amount { 1.5 }
    claim_count { 1 }
    download_link { 'MyText' }
    council { FactoryBot.create :council }
    batch_date { '2018-07-23 16:38:47' }
  end
end
