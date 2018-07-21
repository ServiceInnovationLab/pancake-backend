# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/councils/index', type: :view do
  before do
    assign(
:councils, [
             Council.create!(
               name: 'Tahi',
               active: false
             ),
             Council.create!(
               name: 'Rua',
               active: false
             )
           ])
  end

  it 'renders a list of councils' do
    render
    assert_select 'tr>td', text: 'Tahi', count: 1
    assert_select 'tr>td', text: 'Rua', count: 1
  end
end
