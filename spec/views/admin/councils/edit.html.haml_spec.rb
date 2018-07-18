# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/councils/edit', type: :view do
  before(:each) do
    @council = assign(:council, FactoryBot.create(:council))
  end

  it 'renders the edit council form' do
    render

    assert_select 'form[action=?][method=?]', admin_council_path(@council), 'post' do
      assert_select 'input#council_name[name=?]', 'council[name]'
      assert_select 'input#council_active[name=?]', 'council[active]'
    end
  end
end
