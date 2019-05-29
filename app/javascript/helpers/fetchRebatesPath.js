export function getPath (value) {
  switch(value) {
  case 'not signed':
    return `rebate_forms?utf8=✓&status=not signed&name=${name || ''}`;
  case 'signed':
    return 'rebate_forms?utf8=✓&status=signed';
  case 'processed':
    return 'rebate_forms/processed';
  default:
    return 'rebate_forms?utf8=✓&status=not signed';
  }
}