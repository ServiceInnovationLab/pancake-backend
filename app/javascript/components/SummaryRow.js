import React from 'react';

export function SummaryRow (rebateForm, key, checked, checkIt) {
  const { property, fields, id } = rebateForm;
  const { full_name } = fields;

  const isChecked = checked.indexOf(id) >= 0;
  return (
    <tr key={`${key}-${full_name}`} className='rebate_form.completed'>
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
      {property
        ? <td className='rebate-results-table-cell'>{property.location} <br/> {property.suburb} <br/>  {property.town_city}</td>
        : <td className='rebate-results-table-cell' />
      }
      <td className='rebate-results-table-cell'>
        <a onClick={() => {
          window.location = `/admin/rebate_forms/${id}`;
        }
        }>
          <img className='rebate-form-blue-arrow'src='/assets/blue-right-arrow.svg' alt="blue coloured right arrow"/>
        </a>
      </td>
    </tr>
  );
}