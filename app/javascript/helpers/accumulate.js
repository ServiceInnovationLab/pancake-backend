import { reduce } from 'lodash';

export function accumulate(obj) {
  return reduce(obj, (sum, value) => sum + Number(value || 0), 0);
}