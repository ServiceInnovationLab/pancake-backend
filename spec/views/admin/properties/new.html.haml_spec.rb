# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/properties/new', type: :view do
  before(:each) do
    assign(:admin_property, Admin::Property.new)
  end

  it 'renders new admin_property form' do
    render

    assert_select 'form[action=?][method=?]', admin_properties_path, 'post' do
    end
  end
end
