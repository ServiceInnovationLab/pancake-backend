# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/show', type: :view do
  before do
    @rebate_form = assign(:rebate_form, FactoryBot.create(:rebate_form))
    @rebate_form = assign(:signatures, 'applicant': nil)
  end

  it 'renders attributes in <p>' do
    render
  end
end
