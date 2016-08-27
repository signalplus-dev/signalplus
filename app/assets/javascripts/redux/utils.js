import { CALL_API } from 'redux-api-middleware';
import restInterface from '../util/restInterface.js';

/**
 * Creates a Redux API initiating action
 * @param  {Object} options
 * @return {Object}
 */
export const createRequestAction = ({
  endpoint = '',
  method = 'GET',
  headers,
  token,
  body,
  types = [ 'REQUEST', 'REQUEST_SUCCESS', 'REQUEST_FAIL' ],
  jsonHeaders = true,
  bailout,
}) => ({
  [CALL_API]: {
    endpoint,
    method,
    headers: () => {
      if (headers) return headers;
      return restInterface.requestHeaders();
    },
    body,
    types,
    bailout,
  },
});
