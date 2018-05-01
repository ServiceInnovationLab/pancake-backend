# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/index', type: :view do
  before do
    FactoryBot.create_list(:rebate_form, 2)
    assign(:rebate_forms, RebateForm.all.page(0))
  end

  it 'renders a list of admin/rebate_forms' do
    render
  end
end
