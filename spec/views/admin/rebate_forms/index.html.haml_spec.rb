# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/index', type: :view do
  before do
    FactoryBot.create_list(:rebate_form, 2)
    assign(:rebate_forms, RebateForm.all.page(0))
    render
  end

  xit { expect(rendered).to include 'Not Signed' }
  xit { expect(rendered).to include 'Signed' }
  xit { expect(rendered).to include 'Eg. John Doe' }
end
