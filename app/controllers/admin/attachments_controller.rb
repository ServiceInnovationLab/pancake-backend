# frozen_string_literal: true

class Admin::AttachmentsController < Admin::BaseController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize @file.record, :update?
    @file.purge
    redirect_to admin_rebate_form_path(@file.record)
  end
end
