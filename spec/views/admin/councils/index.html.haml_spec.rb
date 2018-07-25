# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/councils/index', type: :view do
  let(:admin_user) { FactoryBot.create :admin_user }

  before do
    assign(
      :councils, [
        FactoryBot.create(
:council,
                          name: 'Tahi',
                          active: false),
        FactoryBot.create(
:council,
                          name: 'Rua',
                          active: false)
      ]
    )
  end

  it 'renders a list of councils' do
    render
    assert_select 'tr>td', text: 'Tahi', count: 1
    assert_select 'tr>td', text: 'Rua', count: 1
  end
end
