# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/councils/show', type: :view do
  before do
    @council = assign(
      :council, Council.create!(
                  name: 'Name',
                  active: false
                                ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
