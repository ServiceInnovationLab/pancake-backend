# frozen_string_literal: true

RSpec.shared_examples 'percy snapshot' do
  # Tell faker gem to use the same random fakes every time
  # So it doesn't change on every percy run
  before { Faker::Config.random = Random.new(42) }
  subject(:example_name) do |example|
    example.metadata[:full_description]
  end
  after { Percy.snapshot(page, name: example_name, widths: [1280]) }
end
