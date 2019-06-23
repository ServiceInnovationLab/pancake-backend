
export function parseFromAPI (rebateForm) {
  const { fields, location, valuation_id, total_rates } = rebateForm;

  return  { ...fields, location, valuation_id, total_rates };
}

export function prepareForAPI (allFields, council) {
  const { location, valuation_id, total_rates, ...fields} = allFields;

  return { fields, location, valuation_id, total_rates, council: council.name };
}