# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let!(:rebate_form) { FactoryBot.create(:rebate_form, property: property) }

  it "Anonymous can't see it" do
    visit "/admin/rebate_forms/#{rebate_form.id}"
    expect(page).to have_text('Rates Rebate - The Future and Beyond')
    expect(page).to have_text('Log in')
    expect(page).not_to have_text('Log out x')
  end

  context 'when signed in as an admin user' do
    context 'and the user doesn\'t have a name' do
      let(:user) { FactoryBot.create :admin_user, email: 'somebody.important@dia.govt.nz' }

      before { login_as(user, scope: :user) }

      context 'and the rebate form is not completed' do
        before { visit "/admin/rebate_forms/#{rebate_form.id}" }
        it 'viewing council details' do
          expect(page).to have_text(user.email)
          expect(page).to have_text('LOG OUT x')
          expect(page).to have_text('Rates Rebate')
          expect(page).to have_text('Application details')
          expect(page).to have_text('Signature required')
          expect(page).to have_text('Council details')
          expect(page).to have_text('Valuation ID')
          expect(page).to have_text(rebate_form.valuation_id)
          expect(page).to have_text('Customer ID')
          expect(page).to have_text(rebate_form.customer_id)
          expect(page).to have_text('Application ID')
          expect(page).to have_text(rebate_form.application_id)
        end
        include_examples 'percy snapshot'

        it 'viewing customer details' do
          expect(page).to have_text(user.email)
          expect(page).to have_text('LOG OUT x')
          expect(page).to have_text('Application details')
          expect(page).to have_text('Signature required')
          expect(page).to have_text('Customer details')
          expect(page).to have_field('fields.full_name', with: rebate_form.full_name)
          expect(page).to have_field('fields.email', with: rebate_form.email)
          expect(page).to have_field('fields.occupation', with: rebate_form.occupation)
        end
        include_examples 'percy snapshot'

        context 'when the back link is clicked' do
          describe 'goes to the right place' do
            before do
              visit "/admin/rebate_forms/#{rebate_form.id}"
              click_link('back')
            end
            it { expect(page).to have_text('Rates Rebate - The Future and Beyond') }
          end
        end

        context 'when the reload button is clicked' do
          it 'goes to the right place' do
            visit "/admin/rebate_forms/#{rebate_form.id}"
            expect(page).to have_field('fields.full_name', with: rebate_form.full_name)
            updated_attributes = rebate_form.attributes.merge(
              'fields' => { 'full_name': 'bob the builder' }
            )
            RebateFormsUpdateService.new(updated_attributes).update!
            click_link('reload')
            expect(page).to have_field('fields.full_name', with: 'bob the builder')
          end
        end

        context 'when the edit buttons are clicked' do
          context 'editing council details' do
            it 'goes to the right place' do
              visit "/admin/rebate_forms/#{rebate_form.id}"
              click_link('edit-council')
              expect(page).to_not have_text('EDIT')
              expect(page).to have_text('Council details')
              expect(page).to have_text('Signature required')
              expect(page).to have_field(with: rebate_form.valuation_id)
            end
          end

          context 'editing customer details' do
            it 'goes to the right place' do
              visit "/admin/rebate_forms/#{rebate_form.id}"
              click_link('edit-customer')
              expect(page).to_not have_text('EDIT')
              expect(page).to_not have_text('Council details')
              expect(page).to have_text('Signature required')
              expect(page).to have_field(with: rebate_form.full_name)
            end
          end
        end
      end

      context 'when the rebate form is signed' do
        before { rebate_form.transition_to_signed_state }

        describe ' Can see council details' do
          before { visit "/admin/rebate_forms/#{rebate_form.id}" }
          it { expect(page).to have_text('Council details') }
          it { expect(page).to have_text('Signed and ready to process') }
          it { expect(page).to have_text('Process') }
          it { expect(page).to have_field('fields.full_name', with: rebate_form.full_name) }
          it { expect(page).to have_text('Valuation ID') }
          it { expect(page).to have_text(rebate_form.valuation_id) }
          it { expect(page).to have_text('Customer ID') }
          it { expect(page).to have_text(rebate_form.customer_id) }
          it { expect(page).to have_text('Application ID') }
          it { expect(page).to have_text(rebate_form.application_id) }
        end

        describe ' Can see customer details' do
          before { visit "/admin/rebate_forms/#{rebate_form.id}" }
          it { expect(page).to have_text('Application details') }
          it { expect(page).to have_text('Signed and ready to process') }
          it { expect(page).to have_text('Process') }
          it { expect(page).to have_field('fields.full_name', with: rebate_form.full_name) }
          it { expect(page).to have_field('fields.email', with: rebate_form.email) }
          it { expect(page).to have_field('fields.occupation', with: rebate_form.occupation) }
        end

        describe 'can process an application' do
          before { visit "/admin/rebate_forms/#{rebate_form.id}" }

          it 'processes the application' do
            click_link('Process')
            expect(page).to_not have_text('Signed and ready to process')
            expect(page).to have_text('Processed')
          end
        end

        describe 'when a rebate form is processed' do
          let!(:processed_rebate_form) { FactoryBot.create(:processed_form, property: property) }
          before { visit "/admin/rebate_forms/#{processed_rebate_form.id}" }

          it 'cannot be edited' do
            expect(page).to have_text('Processed')
            expect(page).to have_text('Unprocess')
            expect(page).to_not have_text('EDIT')
            expect(page).to have_field(with: processed_rebate_form.full_name)
          end

          it 'can be unprocessed' do
            expect(page).to have_text('Processed')
            expect(page).to have_text('Unprocess')
            click_link('Unprocess')
            expect(page).to have_text('Signed and ready to process')
            expect(page).to_not have_text('Processed')
            expect(page).to have_text('EDIT')
          end
        end

        describe 'when a rebate form is batched' do
          let!(:batched_rebate_form) { FactoryBot.create(:batched_form, property: property) }
          before { visit "/admin/rebate_forms/#{batched_rebate_form.id}" }

          it 'cannot be edited' do
            expect(page).to_not have_text('Processed')
            expect(page).to_not have_text('Unprocess')
            expect(page).to_not have_text('EDIT')
          end
        end
        include_examples 'percy snapshot'
      end

      context 'when the generate QR button is clicked' do
        describe 'requests the QR code' do
          before do
            Timecop.freeze(Time.zone.local(2019, 9, 1, 10, 5, 0))
            visit "/admin/rebate_forms/#{rebate_form.id}/"
            # Freeze time when we generate the qr
            find("img[class='rebate-generate-qr']").click
          end

          it { expect(page).to have_link 'DONE' }

          it 'displays the qr code' do
            expect(page).to have_css('img.rebate-qrcode')
          end
          include_examples 'percy snapshot'
          after { Timecop.return }
        end
      end
    end

    context 'when the user has a name' do
      let(:user) do
        FactoryBot.create :admin_user, name: 'George Foreman', email: 'frontlinestaff@regionalcouncil.govt.nz'
      end

      before { login_as(user, scope: :user) }

      it ' Can see customer details' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text('Application details')
        expect(page).to have_text('Signature required')
        expect(page).to have_text(user.name)
        expect(page).to have_text('LOG OUT x')
      end
    end
  end
end
