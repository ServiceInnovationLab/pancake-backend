# frozen_string_literal: true

class Admin::BatchesController < Admin::BaseController
  respond_to :json, :html

  def index
    @batches = policy_scope(Batch)
               .all
               .order(created_at: :asc)
               .to_json(include: { rebate_forms: { include: :property } })
  end

  def edit
    @batch = Batch.find(params[:id])
    authorize @batch
  end

  def update
    batch = Batch.find(params[:id])
    authorize batch

    batch.update!(name: batch_name_param)

    redirect_to admin_batches_path, notice: 'The selected batch has been updated successfully.'
  end

  def show
    @batch = Batch.find(params[:id])
    authorize @batch
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: pdf_filename, page_size: 'A4', layout: 'pdf', margin: { top: 0, bottom: 0, left: 0, right: 0 }, dpi: '300', show_as_html: params[:debug]
      end
    end
  end

  def create
    rebate_forms = params[:ids].map { |id| policy_scope(RebateForm).find(id) }

    batch = Batch.new(
      council: find_council(rebate_forms),
      amount: batch_amount(rebate_forms),
      batch_date: rebate_forms.last.created_at,
      claim_count: rebate_forms.size
    )
    authorize batch

    Batch.transaction do
      batch.save
      rebate_forms.each do |form|
        form.transition_to_batched_state(batch)
      end
    end
  end

  private

  def batch_name_param
    params.require(:batch).require(:name).strip
  end

  def find_council(rebate_forms)
    return current_user.council if current_user.council

    rebate_forms.first.council
  end

  def pdf_filename
    "batch-#{@batch.council.short_name}-#{@batch.id}"
  end

  def batch_amount(rebate_forms)
    rebate_forms.map(&:rebate).sum
  end
end
