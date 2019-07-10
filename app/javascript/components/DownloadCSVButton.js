import React from 'react';

export function DownloadCSVButton() {
  return (
    <a
      target='_blank'
      rel='noopener'
      className='rebate-bulk-action-button'
      onClick={() => {
        window.open('/admin/rebate_forms/signed/download_csv');
      }}>
        Download CSV
    </a>
  );
}
