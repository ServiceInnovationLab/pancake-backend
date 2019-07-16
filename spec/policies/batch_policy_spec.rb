# frozen_string_literal: true

require 'rails_helper'

describe BatchPolicy do
  subject { described_class.new(user, rebate_form) }

  shared_examples 'can do nothing' do
    let(:rebate_form) { FactoryBot.create(:rebate_form) }
    it { is_expected.not_to permit(:index)   }
    it { is_expected.not_to permit(:show)    }
    it { is_expected.not_to permit(:create)  }
    it { is_expected.not_to permit(:update)  }
  end

  shared_examples 'can read only' do
    let(:rebate_form) { FactoryBot.create(:rebate_form) }
    it { is_expected.to permit(:index)   }
    it { is_expected.to permit(:show)    }
    it { is_expected.not_to permit(:create)  }
    it { is_expected.not_to permit(:update)  }
  end

  shared_examples 'can create, read, and update' do
    let(:rebate_form) { FactoryBot.create(:rebate_form) }
    it { is_expected.to permit(:index)   }
    it { is_expected.to permit(:show)    }
    it { is_expected.to permit(:create)  }
    it { is_expected.to permit(:update)  }
  end

  context 'for a visitor' do
    let(:user) { nil }

    include_examples 'can do nothing'
  end

  context 'for a user with no council' do
    let(:user) { FactoryBot.create(:user, council: nil) }

    include_examples 'can do nothing'
  end

  context 'for a user with same council' do
    let(:user) { FactoryBot.create(:user, council_id: rebate_form.council.id) }

    include_examples 'can create, read, and update'
  end

  context 'for a user with different council' do
    let(:user) { FactoryBot.create(:user, council: nil) }

    include_examples 'can do nothing'
  end

  context 'for a user from DIA' do
    let(:user) { FactoryBot.create(:admin_user, council: nil) }

    include_examples 'can read only'
  end

  # DIA users should be forbidden from creating batches because they can see
  # forms from multiple councils at the same time, which shouldn't be allowed in
  # the same batch
  #
  # This is an unusual case because the user should be forbidden from an action
  # normally allowed to one of their roles
  context 'for a user from DIA AND the same council' do
    let(:user) { FactoryBot.create(:admin_user, council: rebate_form.council) }

    include_examples 'can read only'
  end
end
