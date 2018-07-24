# frozen_string_literal: true

module Admin::SignaturesHelper
  def signature_image_path(signature)
    "#{admin_signature_path}?" + {
      type: signature.signature_type.name,
      token: @rebate_form.token,
      valuation_id: @rebate_form.valuation_id
    }.to_param
  end

  def signature_for_pdf(signature)
    file = Tempfile.new(["signature-#{signature.id}", '.png'], encoding: 'ascii-8bit')
    file.write(Base64.decode64 signature.image)
    wicked_pdf_image_tag file.path, width: 100, height: 100, alt: 'signature', border: 1
  end
end
