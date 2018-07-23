# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create :user }
  it { expect { user.destroy }.to change { User.count }.by(-1) }
  it { expect { user.destroy }.not_to change { User.with_deleted.count } }
end
