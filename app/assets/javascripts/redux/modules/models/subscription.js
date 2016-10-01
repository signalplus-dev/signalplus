import { handleActions } from 'redux-actions';
import { createRequestAction } from '../../utils.js';
import Endpoints, { updateSubscriptionEndpoint } from '../../../util/endpoints.js';
import { normalizeSubscription } from '../../../util/normalize.js';
import _ from 'lodash';
import {
  BRAND_REQUEST,
  BRAND_REQUEST_SUCCESS,
  BRAND_REQUEST_FAIL,
} from './brand.js';

const SUBSCRIPTION_REQUEST = 'signalplus/subscription/SUBSCRIPTION_REQUEST';
const SUBSCRIPTION_REQUEST_SUCCESS = 'signalplus/subscription/SUBSCRIPTION_REQUEST_SUCCESS';
const SUBSCRIPTION_REQUEST_FAIL = 'signalplus/subscription/SUBSCRIPTION_REQUEST_FAIL';

const SUBSCRIPTION_CREATE_REQUEST = 'signalplus/subscription/SUBSCRIPTION_CREATE_REQUEST';
const SUBSCRIPTION_CREATE_REQUEST_SUCCESS = 'signalplus/subscription/SUBSCRIPTION_CREATE_REQUEST_SUCCESS';
const SUBSCRIPTION_CREATE_REQUEST_FAIL = 'signalplus/subscription/SUBSCRIPTION_CREATE_REQUEST_FAIL';

const SUBSCRIPTION_UPDATE_REQUEST = 'signalplus/subscription/SUBSCRIPTION_UPDATE_REQUEST';
const SUBSCRIPTION_UPDATE_REQUEST_SUCCESS = 'signalplus/subscription/SUBSCRIPTION_UPDATE_REQUEST_SUCCESS';
const SUBSCRIPTION_UPDATE_REQUEST_FAIL = 'signalplus/subscription/SUBSCRIPTION_UPDATE_REQUEST_FAIL';

/*
* Initial State
*/
export const initialState = {
  data: {},
  loaded: false,
  loading: false,
};

const handleSubscriptionRequestSucccess = (state, action) => ({
  ...state,
  data: _.get(action, 'payload.subscription'),
  loading: false,
});

/*
* Reducer
*/
export const reducer = handleActions({
  [BRAND_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
  }),

  [BRAND_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    ...normalizeSubscription(action.payload),
  }),

  [BRAND_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),
  [SUBSCRIPTION_CREATE_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
  }),

  [SUBSCRIPTION_CREATE_REQUEST_SUCCESS]: handleSubscriptionRequestSucccess,

  [SUBSCRIPTION_CREATE_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
  }),

  [SUBSCRIPTION_UPDATE_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
  }),

  [SUBSCRIPTION_UPDATE_REQUEST_SUCCESS]: handleSubscriptionRequestSucccess,

  [SUBSCRIPTION_UPDATE_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
  }),
}, initialState);

export function createSubscription(formData) {
  return createRequestAction({
    endpoint: Endpoints.SUBSCRIPTIONS,
    method: 'POST',
    body: JSON.stringify(formData),
    types: [
      SUBSCRIPTION_CREATE_REQUEST,
      SUBSCRIPTION_CREATE_REQUEST_SUCCESS,
      SUBSCRIPTION_CREATE_REQUEST_FAIL,
    ],
  });
}

export function updateSubscription({ id, ...formData }) {
  return createRequestAction({
    endpoint: updateSubscriptionEndpoint(id),
    method: 'PUT',
    body: JSON.stringify(formData),
    types: [
      SUBSCRIPTION_UPDATE_REQUEST,
      SUBSCRIPTION_UPDATE_REQUEST_SUCCESS,
      SUBSCRIPTION_UPDATE_REQUEST_FAIL,
    ],
  });
}
