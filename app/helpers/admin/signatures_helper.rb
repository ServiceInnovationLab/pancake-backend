# frozen_string_literal: true

module Admin::SignaturesHelper
  def signature_image_path(signature)
    "#{admin_signature_path}?" + {
      type: signature.signature_type.name,
      token: signature.rebate_form.token,
      valuation_id: signature.rebate_form.valuation_id
    }.to_param
  end

  def signature_for_pdf(signature)
    image_tag "data:image/png;base64,#{signature.image}"
  end
end
