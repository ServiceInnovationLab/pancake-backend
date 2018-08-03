# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/rebate_forms/index', type: :view do
  let(:council) { FactoryBot.create(:council) }
  before do
    FactoryBot.create_list(:rebate_form, 2)
    assign(:council, council)
    assign(:rebate_forms, RebateForm.all.page(0))
    assign(:years, ['2018', '2019'])
    render
  end
  it { expect(rendered).to include council.name }
  it { expect(rendered).to include '2018' }
  it { expect(rendered).to include '2019' }
end
