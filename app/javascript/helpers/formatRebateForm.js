
export function parseFromAPI (rebateForm, property, ratesBills) {
  const { location, valuation_id }  = property;
  const { total_rates } = ratesBills[0];
  const { fields } = rebateForm;

  return  { ...fields, location, valuation_id, total_rates };
}

export function prepareForAPI (allFields, council) {
  const { location, valuation_id, total_rates, ...fields} = allFields;

  return { fields, location, valuation_id, total_rates, council: council.name };
}