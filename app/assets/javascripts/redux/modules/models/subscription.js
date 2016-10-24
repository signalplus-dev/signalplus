import { handleActions, createAction } from 'redux-actions';
import { createRequestAction } from 'redux/utils.js';
import Endpoints, { updateSubscriptionEndpoint } from 'util/endpoints.js';
import { normalizeSubscription } from 'util/normalize.js';
import { getChannelActionType, subscribedChannels } from 'redux/actionCableSubscriptions.js';
import _ from 'lodash';
import {
  BRAND_REQUEST,
  BRAND_REQUEST_SUCCESS,
  BRAND_REQUEST_FAIL,
} from 'redux/modules/models/brand.js';

const SUBSCRIPTION_REQUEST = 'signalplus/subscription/REQUEST';
const SUBSCRIPTION_REQUEST_SUCCESS = 'signalplus/subscription/REQUEST_SUCCESS';
const SUBSCRIPTION_REQUEST_FAIL = 'signalplus/subscription/REQUEST_FAIL';

const SUBSCRIPTION_CREATE_REQUEST = 'signalplus/subscription/create/REQUEST';
const SUBSCRIPTION_CREATE_REQUEST_SUCCESS = 'signalplus/subscription/create/REQUEST_SUCCESS';
const SUBSCRIPTION_CREATE_REQUEST_FAIL = 'signalplus/subscription/create/REQUEST_FAIL';

const SUBSCRIPTION_UPDATE_REQUEST = 'signalplus/subscription/update/REQUEST';
const SUBSCRIPTION_UPDATE_REQUEST_SUCCESS = 'signalplus/subscription/update/REQUEST_SUCCESS';
const SUBSCRIPTION_UPDATE_REQUEST_FAIL = 'signalplus/subscription/update/REQUEST_FAIL';

const SUBSCRIPTION_RESPONSE_COUNT_UPDATE = 'signalplus/subscription/SUBSCRIPTION_RESPONSE_COUNT_UPDATE';

const MONTHLY_RESPONSE_COUNT_UPDATE = getChannelActionType(subscribedChannels.MONTHLY_RESPONSE_COUNT_CHANNEL);

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

  [MONTHLY_RESPONSE_COUNT_UPDATE]: (state, action) => ({
    ...state,
    data: {
      ...state.data,
      ...action.payload,
    },
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

export const updateResponseCount = createAction(SUBSCRIPTION_RESPONSE_COUNT_UPDATE);
