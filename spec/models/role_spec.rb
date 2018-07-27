# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'users have roles' do
    let(:user) { FactoryBot.create :user }
    let(:role) { FactoryBot.create :role, name: 'dia', users: [user] }

    it { expect(role.users).to include user }
  end
end
