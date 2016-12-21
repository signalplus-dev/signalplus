import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from 'redux/utils';
import _ from 'lodash';
import Endpoints, { userUpdateEndpoint } from 'util/endpoints';
import { normalizeUserResponse } from 'util/normalize';

/*
* Action Type Constants
*/
export const USER_REQUEST = 'signalplus/user/REQUEST';
export const USER_REQUEST_SUCCESS = 'signalplus/user/REQUEST_SUCCESS';
export const USER_REQUEST_FAIL = 'signalplus/user/REQUEST_FAIL';

export const USER_UPDATE_REQUEST = 'signalplus/user/UPDATE_REQUEST';
export const USER_UPDATE_REQUEST_SUCCESS = 'signalplus/user/UPDATE_REQUEST_SUCESS';
export const USER_UPDATE_REQUEST_FAIL = 'signalplus/user/UPDATE_REQUEST_FAIL';

function extractUserData(payload) {
  const userData = _.get(payload, 'entities.user');
  return _.omit(_.first(_.values(userData)), 'brand');
}

/*
* Initial State
*/
export const initialState = {
  data: {},
  loaded: false,
  loading: false,
}

/*
* Reducer
*/
export const reducer = handleActions({
  [USER_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
  }),

  [USER_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: { ...extractUserData(action.payload) },
    loaded: true,
    loading: false,
  }),

  [USER_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),

  [USER_UPDATE_REQUEST]: (state,action) => ({
    ...state,
    loading: true,
  }),

  [USER_UPDATE_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: { ...extractUserData(action.payload) },
    loading: false,
  }),

  [USER_UPDATE_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
  }),

}, initialState);

export const fetchUserData = () => {
  return createRequestAction({
    endpoint: Endpoints.USER,
    types: [
      USER_REQUEST,
      { type: USER_REQUEST_SUCCESS, payload: normalizeUserResponse },
      USER_REQUEST_FAIL,
    ],
  });
}

export function getUserData() {
  return getDataFor(
    'user',
    fetchUserData
  );
}

/**
  * Sample update payload should look like:
  *   {
  *     user: {
  *       email: 'test@example.com',
  *       email_subscription: true,
  *     },
  *     brand: {
  *       tz: 'America/New_York',
  *     }
  *   }
  */
export function updateUserInfo(payload) {
  return (dispatch, getState) => {
    const userId = _.get(getState(), 'models.user.data.id');

    return dispatch(createRequestAction({
      endpoint: userUpdateEndpoint(userId),
      method: 'POST',
      body: JSON.stringify(payload),
      types: [
        USER_UPDATE_REQUEST,
        { type: USER_UPDATE_REQUEST_SUCCESS, payload: normalizeUserResponse },
        USER_UPDATE_REQUEST_FAIL,
      ],
    }));
  };
}
