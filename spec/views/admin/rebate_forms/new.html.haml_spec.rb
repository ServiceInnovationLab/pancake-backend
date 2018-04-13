# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/new', type: :view do
  let!(:rebate_form) { FactoryBot.create(:rebate_form) }
  before do
    assign(:rebate_form, rebate_form)
  end

  it 'renders new admin_rebate_form form' do
    render

    assert_select 'form[action=?][method=?]', admin_rebate_forms_path, 'post' do
    end
  end
end
