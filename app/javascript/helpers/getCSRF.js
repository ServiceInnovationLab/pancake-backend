export const getCSRF = () => {
  const element = document.querySelector('meta[name="csrf-token"]');
  if (element) {
    return element.getAttribute('content');
  }
  return '';
};
