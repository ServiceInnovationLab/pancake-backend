# frozen_string_literal: true

module Admin::AttachmentsHelper
  def image_or_link(file)
    link_to url_for(file) do
      image_tag file.variant(resize: '200x200'), class: 'pure-image'
    end
  rescue ActiveStorage::InvariableError
    link_to "File #{file.filename}", url_for(file)
  end
end
