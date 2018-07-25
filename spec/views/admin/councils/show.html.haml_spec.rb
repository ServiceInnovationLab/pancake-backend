# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/councils/show', type: :view do
  let(:council) { FactoryBot.create(:council, name: 'Pohutakawa are pretty', active: false) }

  before { assign(:council, council) }
  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Pohutakawa are pretty/)
    expect(rendered).to match(/false/)
  end
end
