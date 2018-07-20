# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/councils/new', type: :view do
  before do
    assign(:council, Council.new(
                       name: 'MyString',
                       active: false
    ))
  end

  it 'renders new council form' do
    render

    assert_select 'form[action=?][method=?]', admin_councils_path, 'post' do
      assert_select 'input#council_name[name=?]', 'council[name]'

      assert_select 'input#council_active[name=?]', 'council[active]'
    end
  end
end
