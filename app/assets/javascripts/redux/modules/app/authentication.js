import { createAction, handleActions } from 'redux-actions';
import { createRequestAction } from 'redux/utils';
import Endpoints from  'util/endpoints';
import {
  baseHeaders,
  hasToken,
  getAT,
  setTA,
} from 'util/authentication';

const HEADER_CSRF_KEY = 'X-CSRF-TOKEN';

/*
* Action Type Constants
*/
export const AUTHENTICATED = 'signalplus/app/AUTHENTICATED';
const AUTHENTICATION_REQUEST = 'signalplus/authentication/REQUEST';
const AUTHENTICATION_REQUEST_SUCCESS = 'signalplus/authentication/REQUEST_SUCCESS';
const AUTHENTICATION_REQUEST_FAIL = 'signalplus/authentication/REQUEST_FAIL';

const authenticated = createAction(AUTHENTICATED);

const requestAuthentication = () => {
  return createRequestAction({
    endpoint: Endpoints.TOKEN,
    method: 'POST',
    credentials: 'same-origin',
    headers: {
      ...baseHeaders(),
      [HEADER_CSRF_KEY]: getAT(),
    },
    body: '',
    types: [
      AUTHENTICATION_REQUEST,
      {
        type: AUTHENTICATION_REQUEST_SUCCESS,
        payload: (action, state, response) => {
          setTA(response);
        },
      },
      AUTHENTICATION_REQUEST_FAIL,
    ],
  });
};

/**
  * Create a thunk that authenticates the user
  */
export const authenticate = () => (dispatch, getState) => {
  if (!hasToken()) {
    return dispatch(requestAuthentication()).then(() => dispatch(authenticated()));
  }

  return dispatch(authenticated());
}
