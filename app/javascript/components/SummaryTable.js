import React from 'react';
import { map } from 'lodash';

import { SummaryRow } from './SummaryRow';

export function SummaryTable (rebateForms) {
  return (
    <div className="pure-u-1">
      <table className="pure-table pure-table-bordered rebate-results-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Address</th>
            <th></th>
          </tr>
        </thead>
        <tbody className='rebate-results-table-body'>
          { map(rebateForms, (rebateForm, key) => SummaryRow(rebateForm, key))}
        </tbody>
      </table>
    </div>
  );          
}