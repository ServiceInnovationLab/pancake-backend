export function getCurrentPath (pathname) {
  const currentPath = pathname.substring(pathname.lastIndexOf('/') + 1);

  switch(currentPath) {
  case 'batches':
    return 'batches';
  case 'processed':
    return 'processed';
  case 'signed':
    return 'signed';
  case 'admin':
  default:
    return 'admin';
  } 
}
