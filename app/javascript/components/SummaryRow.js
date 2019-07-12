import React from 'react';

export function SummaryRow(rebateForm, key, checked, checkIt) {
  const { location, valuation_id, fields, id } = rebateForm;
  const { full_name } = fields;

  const isChecked = checked.indexOf(id) >= 0;
  return (
    <tr key={`${key}-${full_name}`} className='rebate-form--completed'>
      {checkIt && <td className='rebate-results-table-cell'>
        <input
          type="checkbox"
          aria-label={`select-${full_name}-checkbox`}
          id={`${full_name}-checkbox`}
          checked={isChecked}
          onChange={() => checkIt(key)}
        />
      </td>
      }
      <td className='rebate-results-table-cell'>{fields.full_name}</td>
      {checkIt && valuation_id &&
        <td className='rebate-results-table-cell' id='valuation-id'>{valuation_id} </td>
      }
      {checkIt && !valuation_id &&
        <td className='rebate-results-table-cell'></td>
      }
      {!checkIt &&
        <td className='rebate-results-table-cell'>{location}</td>
      }
      {checkIt &&
        <td className='rebate-results-table-cell' id='application-id'>
          { rebateForm.application_id
            ? rebateForm.application_id
            : ''
          }
        </td>
      }
      <td className='rebate-results-table-cell'>
        <a onClick={() => {
          window.location = `/admin/rebate_forms/${id}`;
        }}>
          <img className='rebate-form-blue-arrow'src='/assets/blue-right-arrow.svg' alt="blue coloured right arrow"/>
        </a>
      </td>
    </tr>
  );
}
