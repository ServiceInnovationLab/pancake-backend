# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/properties/edit', type: :view do
  before(:each) do
    @admin_property = assign(:admin_property, Admin::Property.create!)
  end

  it 'renders the edit admin_property form' do
    render

    assert_select 'form[action=?][method=?]', admin_property_path(@admin_property), 'post' do
    end
  end
end
