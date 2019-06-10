import React from 'react';
import { map } from 'lodash';

import {summaryTabs} from '../helpers/data';

const currentLocation = window.location.pathname;

export function SummaryTabs () {
  return (
    <div className={'rebate-tabs flex-row'}>
      {map(summaryTabs, ([key, value]) =>
        <button key={key} className={(currentLocation === value) ? 'rebate-button-selected' : 'rebate-button' } onClick={() => window.location = value}>
          {key}
        </button>
      )}
    </div>
  );
}