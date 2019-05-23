# frozen_string_literal: true

RSpec.shared_examples 'percy snapshot' do
  subject(:example_name) do |example|
    example.metadata[:full_description]
  end
  after { Percy.snapshot(page, name: example_name, widths: [1280]) }
end
