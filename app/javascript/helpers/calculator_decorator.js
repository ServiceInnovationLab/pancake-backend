import { reduce } from 'lodash'

import createDecorator from 'final-form-calculate'
import { accumulate } from "../helpers/accumulate";

export const calculator = createDecorator(
  {
    field: /\.income/, // when a field matching this pattern changes...
    updates: {
      // ...update the total_income to the result of this function
      ['fields.income.total_income']: (newValue, allValues) => {
        const { applicant, partner, other_income } = allValues.fields.income
        const applicantValues = accumulate(applicant)
        const partnerValues = accumulate(partner)
        const otherValues = reduce(other_income, (sum, obj) => sum + accumulate(obj), 0)
        const total = applicantValues + partnerValues + otherValues    
        return total
      }
    }
  }
)