import createDecorator from 'final-form-calculate';
import { accumulate } from './accumulate';

export const calculator = createDecorator(
  {
    field: /(\.income)|(fields\.spouse_or_partner)/, // when an income field or spouse_or_partner changes
    updates: {
      // ...update the total_income
      ['fields.income.total_income']: (newValue, allValues) => {
        const { applicant, partner, otherIncome = {} } = allValues.fields.income;
        const {applicant: otherApplicant = {}, partner: otherPartner = {} } = otherIncome;

        const includePartnerValues = allValues.fields.spouse_or_partner == 'yes';
        
        const applicantValues = accumulate({...applicant, ...otherApplicant});
        const partnerValues = includePartnerValues && accumulate({...partner, ...otherPartner});

        const total = applicantValues + partnerValues;
        return total.toFixed(2); 
      }
    }
  }
);
