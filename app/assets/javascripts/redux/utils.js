import { CALL_API } from 'redux-api-middleware';
import _ from 'lodash';
import { requestHeaders, clearTA } from 'util/authentication.js';
import Endpoints from 'util/endpoints.js'

/**
 * Creates a Redux API initiating action
 * @param  {Object} options
 * @return {Object}
 */
export const createRequestAction = ({
  endpoint = '',
  method = 'GET',
  headers,
  credentials,
  token,
  body,
  types = [ 'REQUEST', 'REQUEST_SUCCESS', 'REQUEST_FAIL' ],
  jsonHeaders = true,
  bailout,
}) => ({
  [CALL_API]: {
    endpoint,
    method,
    credentials,
    headers: () => {
      if (headers) return headers;
      return requestHeaders();
    },
    body,
    types,
    bailout,
  },
});

export function getDataFor(pathToModel, fetchCallback) {
  return (dispatch, getState) => {
    const model = _.get(getState(), `models.${pathToModel}`);

    if (model && (model.loaded || model.loading)) {
      return Promise.resolve();
    }

    return dispatch(fetchCallback());
  }
}

const LOG_OUT_REQUEST = 'signalplus/app/LOG_OUT_REQUEST';
const LOG_OUT_REQUEST_SUCCESS = 'signalplus/app/LOG_OUT_REQUEST_SUCCESS';
const LOG_OUT_REQUEST_FAIL = 'signalplus/app/LOG_OUT_REQUEST_FAIL';

const apiLogOutRequest = () => {
  return createRequestAction({
    endpoint: Endpoints.TOKEN_SIGN_OUT,
    method: 'DELETE',
    types: [
      LOG_OUT_REQUEST,
      LOG_OUT_REQUEST_SUCCESS,
      LOG_OUT_REQUEST_FAIL,
    ],
  });
};

export const logOut = () => (dispatch, getState) => {
  return dispatch(apiLogOutRequest()).then(() => clearTA());
};
