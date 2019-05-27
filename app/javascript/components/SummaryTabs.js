import React from 'react';
import { map } from 'lodash';

export function SummaryTabs (applicationState, onChange) {
  return (
    <div className={'rebate-tabs flex-row'}>
      {map([['Not Signed', 'not-completed'], ['Signed', 'completed']], ([key, value]) =>
        <button key={key} className={(applicationState === value) ? 'rebate-button-selected' : 'rebate-button' } onClick={() => onChange(value)}>
          {key}
        </button>
      )}
    </div>
  );
}