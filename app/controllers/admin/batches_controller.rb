# frozen_string_literal: true

class Admin::BatchesController < Admin::BaseController
  respond_to :json, :html

  rescue_from Pundit::NotAuthorizedError, with: :user_not_in_council

  def index
    @batches = policy_scope(Batch)
               .all
               .order(created_at: :desc)
               .to_json(include: [:rebate_forms])
  end

  def edit
    @batch = Batch.find(params[:id])
    authorize @batch
  end

  def update
    batch = Batch.find(params[:id])
    authorize batch

    Batch.transaction do
      update_batch(batch)
    end

    redirect_to admin_batches_path, notice: 'The selected batch has been updated successfully.'
  end

  def show
    @batch = Batch.find(params[:id])
    authorize @batch
  end

  def create
    rebate_forms = params[:ids].map { |id| policy_scope(RebateForm).find(id) }

    batch = Batch.new(
      council: find_council(rebate_forms),
      batch_date: rebate_forms.last.created_at,
      claim_count: rebate_forms.size
    )
    authorize batch

    Batch.transaction do
      batch.save!
      rebate_forms.each do |form|
        form.transition_to_batched_state(batch)
      end
    end
  end

  private

  def update_batch(batch)
    batch.header_sheet.attach(batch_header_sheet_param) unless batch_header_sheet_param.nil?
    batch.update!(name: batch_name_param) unless batch_name_param.nil?
    batch.update!(header_sheet_attached: true, download_link: header_sheet_url(batch)) if batch.erms_header_sheet_attached?
  end

  def header_sheet_url(batch)
    rails_blob_path(batch.header_sheet, disposition: 'attachment')
  end

  def batch_name_param
    return nil unless params[:batch][:name]

    params.require(:batch).require(:name).strip
  end

  def batch_header_sheet_param
    return nil unless params[:batch][:header_sheet]

    params.require(:batch).require(:header_sheet)
  end

  def find_council(rebate_forms)
    return current_user.council if current_user.council

    rebate_forms.first.council
  end

  def pdf_filename
    "batch-#{@batch.council.short_name}-#{@batch.id}"
  end

  def user_not_in_council
    flash[:alert] = 'Only users in a council role (who have been assigned to a council) are able to create batches.'
    redirect_back fallback_location: root_path
  end
end
