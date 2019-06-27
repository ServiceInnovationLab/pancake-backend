# frozen_string_literal: true

module Admin::SignaturesHelper
  def signature_image_path(signature)
    "#{admin_signature_path}?" + {
      type: signature.signature_type.name,
      token: signature.rebate_form.token,
      valuation_id: signature.rebate_form.valuation_id
    }.to_param
  end

  def signature_for_pdf(signature, type)
    image = "data:image/png;base64,#{signature.image}" unless signature.image.to_s.start_with?('data:image/png;base64')
    image = signature.image.to_s if signature.image.to_s.start_with?('data:image/png;base64')

    image_tag image, class: type
  end
end
