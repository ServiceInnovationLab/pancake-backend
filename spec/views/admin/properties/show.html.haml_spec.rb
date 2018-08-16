# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/properties/show', type: :view do
  before(:each) do
    @admin_property = assign(:admin_property, Admin::Property.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
