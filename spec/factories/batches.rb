# frozen_string_literal: true

FactoryBot.define do
  factory :batch do
    batch_no 1
    amount 1.5
    claim_count 1
    download_link 'MyText'
    council_id 1
    batch_date '2018-07-23 16:38:47'
  end
end
