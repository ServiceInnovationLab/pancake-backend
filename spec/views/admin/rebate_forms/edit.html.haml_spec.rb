# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/edit', type: :view do
  let(:rebate_form) { FactoryBot.create :rebate_form }

  before do
    @rebate_form = assign(:rebate_form, rebate_form)
  end

  it 'renders the edit rebate_form form' do
    render
    assert_select 'form[action=?][method=?]', admin_rebate_form_path(@rebate_form), 'post' do
    end
  end
end
