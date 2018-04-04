# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/edit', type: :view do
  before(:each) do
    @rebate_form = assign(:rebate_form, RebateForm.create!)
  end

  it 'renders the edit rebate_form form' do
    render

    assert_select 'form[action=?][method=?]', admin_rebate_form_path(@rebate_form), 'post' do
    end
  end
end
