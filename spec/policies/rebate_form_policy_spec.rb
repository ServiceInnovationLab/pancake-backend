# frozen_string_literal: true

require 'rails_helper'

describe RebateFormPolicy do
  subject { described_class.new(user, rebate_form) }

  shared_examples 'can do nothing' do
    let(:rebate_form) { FactoryBot.create(:rebate_form) }
    it { is_expected.not_to permit(:show)    }
    it { is_expected.not_to permit(:create)  }
    it { is_expected.not_to permit(:new)     }
    it { is_expected.not_to permit(:update)  }
    it { is_expected.not_to permit(:edit)    }
    it { is_expected.not_to permit(:destroy) }
  end

  shared_examples 'can delete only unsigned forms' do
    describe 'unsigned form' do
      let(:rebate_form) { FactoryBot.create(:rebate_form) }

      it { is_expected.to permit(:show)    }
      it { is_expected.to permit(:update)  }
      it { is_expected.to permit(:edit)    }
      it { is_expected.to permit(:destroy) }
    end

    describe 'with a fully signed form' do
      let(:rebate_form) { FactoryBot.create(:signed_form) }

      it { expect(rebate_form.status).to eq(RebateForm::SIGNED_STATUS) }
      it { is_expected.to permit(:show) }
      it { is_expected.to permit(:update)  }
      it { is_expected.to permit(:edit)    }
      it { is_expected.not_to permit(:destroy) }
    end
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

    include_examples 'can delete only unsigned forms'
  end

  context 'for a user with different council' do
    let(:user) { FactoryBot.create(:user, council: nil) }

    include_examples 'can do nothing'
  end

  context 'for a user from DIA' do
    let(:user) { FactoryBot.create(:admin_user, council: nil) }

    include_examples 'can delete only unsigned forms'
  end
end
