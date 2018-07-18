# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/show', type: :view do
  let(:user) { FactoryBot.create :user }
  before(:each) do
    @user = assign(:user, user)
  end

  it 'renders attributes in <p>' do
    render
  end
end
