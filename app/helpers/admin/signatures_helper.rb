# frozen_string_literal: true

module Admin::SignaturesHelper
  def signature_image_path(signature)
    "#{admin_signature_path}?" + {
      type: signature.signature_type.name,
      token: @rebate_form.token,
      valuation_id: @rebate_form.valuation_id
    }.to_param
  end
end
