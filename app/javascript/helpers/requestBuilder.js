const appUrl = window.location.origin;
import { getCSRF } from '../helpers/getCSRF';

export function requestBuilder({ method, path, body }) {
  return fetch(`${appUrl}${path}`, {
    method: method,
    headers: {
      'X-CSRF-Token': getCSRF(),
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: body,
    credentials: 'same-origin'
  });
}