import React from 'react';
import { map } from 'lodash';

import { SummaryRow } from './SummaryRow';

export function SummaryTable(rebateForms, checked, checkIt) {
  return (
    <div className="pure-u-1">
      <table className="pure-table pure-table-bordered rebate-results-table">
        <thead>
          <tr>
            {checkIt && <th></th>}
            <th>Name</th>
            <th>Address</th>
            <th></th>
          </tr>
        </thead>
        <tbody className='rebate-results-table-body'>
          { map(rebateForms, (rebateForm, key) => SummaryRow(rebateForm, key, checked, checkIt))}
        </tbody>
      </table>
    </div>
  );
}