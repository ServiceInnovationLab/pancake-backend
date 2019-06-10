import React from 'react';

export function BatchRow (rebateForm) {
  const { property, fields, id } = rebateForm;
  const { full_name } = fields;

  return (
    <div className='batches-flex-table-row' key={`batch-${id}`}>
      <div className='batches-flex-table-first-cell'> {full_name} </div>
      <div className='batches-flex-table-cell'> {property && property.valuation_id} </div>
      <div className='batches-flex-table-cell'>
        <a className='batch-details-link' onClick={() => {
          window.location = `/admin/rebate_forms/${id}`;
        }}>
          DETAILS
          {'\u00A0'}
          <img className='rebate-form-blue-arrow'src='/assets/blue-right-arrow.svg' alt="blue coloured right arrow"/>
        </a>
      </div>
    </div>
  );
}