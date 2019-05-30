import React from 'react';
import { map } from 'lodash';

import {summaryTabs} from '../helpers/data';

export function SummaryTabs (applicationState, onChange) {
  return (
    <div className={'rebate-tabs flex-row'}>
      {map(summaryTabs, ([key, value]) =>
        <button key={key} className={(applicationState === value) ? 'rebate-button-selected' : 'rebate-button' } onClick={() => onChange(value)}>
          {key}
        </button>
      )}
    </div>
  );
}