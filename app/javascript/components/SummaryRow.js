import React from 'react';

const appUrl = window.location.origin;

export function SummaryRow (rebateForm, key) {
  const { property, fields, id } = rebateForm;
  return (
    <tr key={`${key}-${fields.full_name}`} className='rebate_form.completed'>
      <td className='rebate-results-table-cell'>{fields.full_name}</td>
      {property
        ? <td className='rebate-results-table-cell'>{property.location} <br/> {property.suburb} <br/>  {property.town_city}</td>
        : <td className='rebate-results-table-cell' />
      }
      <td className='rebate-results-table-cell'>
        <a onClick={() => {
          window.location = `${appUrl}/admin/rebate_forms/${id}`;
        }
        }>
          <img src='/assets/blue-right-arrow.svg' alt="blue coloured right arrow"/>
        </a>
      </td>
    </tr>
  );
}