export function getCurrentPath(pathname) {
  const currentPath = pathname.substring(pathname.lastIndexOf('/') + 1);

  switch (currentPath) {
  case 'batches':
    return '/admin/batches';
  case 'processed':
    return '/admin/rebate_forms/processed';
  case 'signed':
    return '/admin/rebate_forms/signed';
  case 'rebate_forms':
  default:
    return '/admin/rebate_forms';
  }
}