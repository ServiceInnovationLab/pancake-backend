# frozen_string_literal: true

class Admin::BatchesController < Admin::BaseController
  def index
    @council = current_user.council
    @batches = policy_scope(Batch).all.order(created_at: :desc)
    return if @council.blank?

    @unbatched_count = RebateForm.joins(:property)
                                 .where(status: RebateForm::SIGNED_STATUS,
                                        batch_id: nil,
                                        properties: { council_id: @council.id })
                                 .size
  end

  def show
    @batch = Batch.find(params[:id])
    authorize @batch
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: pdf_filename, page_size: 'A4', layout: 'pdf', margin: { top: 0, bottom: 0, left: 0, right: 0 }, dpi: '300'
      end
    end
  end

  def create
    @council = current_user.council

    @rebate_forms = policy_scope(RebateForm)
                    .joins(:property)
                    .where(status: RebateForm::SIGNED_STATUS,
                           properties: { council: @council },
                           batch: nil)
                    .order(:created_at)
                    .limit(100)

    if @rebate_forms.size.positive?
      @batch = Batch.new(
        council: current_user.council,
        amount: @rebate_forms.sum(:rebate),
        batch_date: @rebate_forms.last.created_at,
        claim_count: @rebate_forms.size
      )
      authorize @batch

      Batch.transaction do
        @batch.save
        @rebate_forms.each do |form|
          form.update(batch: @batch)
        end
      end
    end
    redirect_to admin_batches_path
  end

  private

  def pdf_filename
    "batch-#{@batch.council.short_name}-#{@batch.id}"
  end
end
