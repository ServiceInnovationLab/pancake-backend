# frozen_string_literal: true

class RebateFormsService
  class Error < StandardError; end

  def initialize(rebate_form_attributes)
    @rebate_form_attributes = rebate_form_attributes
  end

  def generate_qr(rebate_form)
    # create a new token that only allows you to fetch a restricted set of details for this application only
    # and use the same token to submit the signatures back
    # this token is valid for 30 minutes

    payload = {
      rebate_form_id: rebate_form.id,
      exp: Time.now.to_i + (ENV['IPAD_JWT_LENGTH'].to_i * 60),
      per: 'fetch_application_and_submit_signatures'
    }

    token = JWT.encode payload, ENV['HMAC_SECRET'], 'HS256'

    # iPad-application URL
    url = `#{ENV['APP_URL']}admin/sign?jwt=#{token}`

    RQRCode::QRCode
      .new(url, size: 20, level: :h)
      .as_png(offset: 0, color: '0', shape_rendering: 'crispEdges', module_size: 10)
      .to_data_url
  end
  def update!
    council = find_council!
    property = create_or_update_property!(council)
    rebate_form = create_or_update_rebate_form!(property)
    create_or_update_rates_bill!(property)
    rebate_form.calc_rebate_amount!
    raise Error if rebate_form.rebate.blank?
    rebate_form
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
    raise Error
  end

  private

  def create_or_update_rebate_form!(property)
    return update_rebate_form!(property) if @rebate_form_attributes['id']
    create_rebate_form!(property)
  end

  def update_rebate_form!(property)
    rebate_form = RebateForm.find_by(id: @rebate_form_attributes['id'])
    property = rebate_form.property if property.id.nil?
    fields_to_update = rebate_form.fields.merge(fields_to_merge)
    rebate_form.update!(property: property, valuation_id: property.valuation_id, fields: fields_to_update)
    rebate_form
  end

  def update_fields
    return @rebate_form_attributes['rebate_form']['fields'] if @rebate_form_attributes['rebate_form']
    @rebate_form_attributes['fields']
  end

  def fields_to_merge
    return update_fields unless update_fields.nil?
    {}
  end

  def create_rebate_form!(property)
    RebateForm.create!(property: property,
                       valuation_id: property.valuation_id,
                       rebate: 0,
                       fields: @rebate_form_attributes['fields'])
  end

  def create_or_update_property!(council)
    return create_or_update_property_with_valuation_id!(council) if @rebate_form_attributes['valuation_id']
    find_or_create_property_with_no_valuation_id!(council)
  end

  def create_or_update_property_with_valuation_id!(council)
    property = Property.find_or_create_by(valuation_id: @rebate_form_attributes['valuation_id'],
                                          rating_year: ENV['YEAR'],
                                          council: council)
    property.update!(location: @rebate_form_attributes['location'])
    property
  end

  def find_or_create_property_with_no_valuation_id!(council)
    Property.find_or_create_by!(location: @rebate_form_attributes['location'],
                                rating_year: ENV['YEAR'],
                                council: council)
  end

  def find_council!
    Council.find_by!(name: @rebate_form_attributes['council'])
  end

  def create_or_update_rates_bill!(property)
    rates_bill = RatesBill.find_or_create_by(property: property,
                                             rating_year: property.rating_year)
    rates_bill.update!(total_rates: @rebate_form_attributes['total_rates'])
    rates_bill
  end
end
