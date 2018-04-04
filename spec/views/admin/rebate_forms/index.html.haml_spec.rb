# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/index', type: :view do
  before do
    assign(:rebate_forms, [
             RebateForm.create!,
             RebateForm.create!
           ])
  end

  it 'renders a list of admin/rebate_forms' do
    render
  end
end
