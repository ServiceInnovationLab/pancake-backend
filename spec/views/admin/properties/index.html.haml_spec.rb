# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/properties/index', type: :view do
  before(:each) do
    assign(:admin_properties, [
             Admin::Property.create!,
             Admin::Property.create!
           ])
  end

  it 'renders a list of admin/properties' do
    render
  end
end
