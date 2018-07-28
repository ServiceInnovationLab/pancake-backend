# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Admin::UsersHelper. For example:
#
# describe Admin::UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Admin::SignaturesHelper, type: :helper do
  def signature_image_path(signature)
    "#{admin_signature_path}?" + {
      type: signature.signature_type.name,
      token: @rebate_form.token,
      valuation_id: @rebate_form.valuation_id
    }.to_param
  end

  def signature_for_pdf(signature)
    image_tag "data:image/png;base64,#{signature.image}"
  end
end
