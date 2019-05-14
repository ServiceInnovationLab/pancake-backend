export const incomeRows = [
  [
    "other_superannuation",
    "Other superannuation"
  ],
  [
    "nz_superannuation",
    "NZ superannuation"
  ],
  [
    "interest_dividends",
    "Interest / Dividends"
  ],
  [
    "wages_salary",
    "Wages or Salary"
  ],
]   

export const conditionalsFields = [
  {
    id: "previous_address",
    label: "Address",
    fullWidth: true
  },
  {
    id: "settlement_date",
    label: "Settlement Date",
    type: "date"
  },
  {
     type: "number"
  },
  {
    id: 'rates_rebate_received',
    label: "Rates rebate received?",
    type:"radio"
  },
]
export const customerDetailFields = [
  {
    id:"full_name",
    label: "Name",
  },
  {
    id:"customer_id",
    label: "Customer ID (optional)",
    placeholder: "0000000",
  },
  {
    id:"location",
    label: "Address",
    fullWidth: true
  },
  {
    id:"total_rates",
    label: "Total Rates",
  },
  {
    id:"valuation_id",
    label: "Valuation ID (optional)",
    placeholder: "00000 000 00",
  },
  {
    id:"email",
    label: "Email",
    type:"email",
  },
  {
    id:"phone_number",
    label: "Phone",
    type:"tel",
  },
  {
    id: 'spouse_or_partner',
    label: "Spouse or Partner",
    type:"radio"
  },
  {
    id:"dependents",
    label: "Dependents",
    type:"number",
    placeholder: "0",
  },
  {
    id:"50%_claimed_expenses",
    label: "50% claimed as expenses?",
    type:"radio"
  },
  {
    id:"occupation",
    label: "Occupation",
  },
  {
    id: 'moved_within_rating_year',
    label: "Moved within rating year?",
    type:"radio"
  },
  {
    id: 'lived_in_property_1_July',
    label: "Lived in property 1 July 2018",
    type:"radio"
  },
]