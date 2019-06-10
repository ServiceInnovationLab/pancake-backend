import React, { Fragment } from 'react';

export function ProcessButtons ({disabled, unProcessRebates, createBatch}) {
  return (
    <Fragment>
      <button 
        className='rebate-bulk-action-button'
        disabled={disabled}
        onClick={unProcessRebates}
      >
        UNPROCESS
      </button>
      <button
        className='rebate-bulk-action-button'
        disabled={disabled}
        onClick={createBatch}
      >
          CREATE BATCH
      </button>
    </Fragment>
  );
}