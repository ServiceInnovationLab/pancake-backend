
export function parseFromAPI (rebateForm, property, ratesBills) {
  const { location }  = property;
  const { total_rates } = ratesBills[0];
  const { fields } = rebateForm;

  return  { ...fields, location, total_rates };
}

export function prepareForAPI (allFields, council) {
  const { location, total_rates, ...fields} = allFields;

  return { fields, location, total_rates, council: council.name };
}