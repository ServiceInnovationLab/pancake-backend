import React from 'react';

const appUrl = window.location.origin;

export function BatchRow (rebateForm) {
  const { property, fields, id } = rebateForm;
  const { full_name } = fields;

  return (
    <div className='flex-row'>
      <div className='batches-flex-table-cell'> {full_name} </div>
      <div className='batches-flex-table-cell'> {property && property.valuation_id} </div>
      <div className='batches-flex-table-cell'>
        <a className='batch-details-link' onClick={() => {
          window.location = `${appUrl}/admin/rebate_forms/${id}`;
        }}>
          DETAILS
          {'\u00A0'}
          <img className='rebate-form-blue-arrow'src='/assets/blue-right-arrow.svg' alt="blue coloured right arrow"/>
        </a>
      </div>
    </div>
  );
}