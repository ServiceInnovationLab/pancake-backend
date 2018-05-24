# frozen_string_literal: true

class Admin::NotesController < Admin::BaseController
  respond_to :html
  def create
    @note = Note.new(notes_params)
    @note.user = current_user
    @note.save
    redirect_to(admin_rebate_form(@note.rebate_form))
  end

  private

  # Only allow a trusted parameter "white list" through.
  def notes_params
    params.require(:note).permit(:body, :rebate_form_id)
  end
end
