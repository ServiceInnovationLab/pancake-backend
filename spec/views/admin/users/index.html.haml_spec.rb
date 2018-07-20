# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/index', type: :view do
  let(:admin_user) { FactoryBot.create :admin_user }
  before(:each) do
    assign(:users, FactoryBot.create_list(:user, 5))
    sign_in admin_user
  end

  it 'renders a list of admin/users' do
    render
  end
end
