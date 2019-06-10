# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Root', type: :request do
  before { get '/' }

  it { expect(response).to redirect_to('/admin') }
end
