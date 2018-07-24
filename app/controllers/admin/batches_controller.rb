# frozen_string_literal: true

class Admin::BatchesController < Admin::BaseController
  def index
    @council = current_user.council
    @batches = policy_scope(Batch).all.order(created_at: :desc)
  end

  def show
    pdf_file_as_String = WickedPdf.new.pdf_from_string(
      render_to_string('admin/rebate_forms/index.pdf.haml', layout: 'pdf')
    )
  end

  def create
    @council = current_user.council
    @rebate_forms = policy_scope(RebateForm).witnessed.joins(:property).where(properties: { council: @council}, batch: nil).order(:created_at).limit(100)
    @batch = Batch.new(
      council: current_user.council,
      amount: @rebate_forms.sum(:rebate),
      batch_date: @rebate_forms.last.created_at,
      claim_count: @rebate_forms.size)
    authorize @batch

    Batch.transaction do
      @batch.save
      @rebate_forms.each do |form|
        form.update(batch: @batch)
      end
    end
    redirect_to admin_batches_path
  end
end
