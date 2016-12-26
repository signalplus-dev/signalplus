import { handleActions, createAction } from 'redux-actions';
import { createRequestAction } from 'redux/utils';
import Endpoints, { updateSubscriptionEndpoint, cancelSubscriptionEndpoint } from 'util/endpoints';
import { normalizeSubscription } from 'util/normalize';
import { getChannelActionType, subscribedChannels } from 'redux/actionCableSubscriptions';
import _ from 'lodash';
import {
  BRAND_REQUEST,
  BRAND_REQUEST_SUCCESS,
  BRAND_REQUEST_FAIL,
} from 'redux/modules/models/brand';

const SUBSCRIPTION_REQUEST = 'signalplus/subscription/REQUEST';
const SUBSCRIPTION_REQUEST_SUCCESS = 'signalplus/subscription/REQUEST_SUCCESS';
const SUBSCRIPTION_REQUEST_FAIL = 'signalplus/subscription/REQUEST_FAIL';

const SUBSCRIPTION_CREATE_REQUEST = 'signalplus/subscription/create/REQUEST';
export const SUBSCRIPTION_CREATE_REQUEST_SUCCESS = 'signalplus/subscription/create/REQUEST_SUCCESS';
export const SUBSCRIPTION_CREATE_REQUEST_FAIL = 'signalplus/subscription/create/REQUEST_FAIL';

const SUBSCRIPTION_UPDATE_REQUEST = 'signalplus/subscription/update/REQUEST';
export const SUBSCRIPTION_UPDATE_REQUEST_SUCCESS = 'signalplus/subscription/update/REQUEST_SUCCESS';
export const SUBSCRIPTION_UPDATE_REQUEST_FAIL = 'signalplus/subscription/update/REQUEST_FAIL';

const SUBSCRIPTION_CANCEL_REQUEST = 'signalplus/subscription/cancel/REQUEST';
export const SUBSCRIPTION_CANCEL_REQUEST_SUCCESS = 'signalplus/subscription/cancel/REQUEST_SUCCESS';
export const SUBSCRIPTION_CANCEL_REQUEST_FAIL = 'signalplus/subscription/cancel/REQUEST_FAIL';

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

  [SUBSCRIPTION_CANCEL_REQUEST_SUCCESS]: handleSubscriptionRequestSucccess,

}, initialState);

export function createSubscription(formData) {
  return createRequestAction({
    endpoint: Endpoints.SUBSCRIPTIONS,
    method: 'POST',
    body: JSON.stringify(formData),
    types: [
      { type: SUBSCRIPTION_CREATE_REQUEST, meta: { spLoading: true } },
      { type: SUBSCRIPTION_CREATE_REQUEST_SUCCESS, meta: { spLoading: false } },
      { type: SUBSCRIPTION_CREATE_REQUEST_FAIL, meta: { spLoading: false } },
    ],
  });
}

export function updateSubscription({ id, ...formData }) {
  return createRequestAction({
    endpoint: updateSubscriptionEndpoint(id),
    method: 'PATCH',
    body: JSON.stringify(formData),
    types: [
      { type: SUBSCRIPTION_UPDATE_REQUEST, meta: { spLoading: true } },
      { type: SUBSCRIPTION_UPDATE_REQUEST_SUCCESS, meta: { spLoading: false } },
      { type: SUBSCRIPTION_UPDATE_REQUEST_FAIL, meta: { spLoading: false } },
    ],
  });
}

export function cancelSubscription({ id }) {
  return createRequestAction({
    endpoint: cancelSubscriptionEndpoint(id),
    method: 'POST',
    types: [
      { type: SUBSCRIPTION_CANCEL_REQUEST, meta: { spLoading: true } },
      { type: SUBSCRIPTION_CANCEL_REQUEST_SUCCESS, meta: { spLoading: false } },
      { type: SUBSCRIPTION_CANCEL_REQUEST_FAIL, meta: { spLoading: false } },
    ],
  })
}

export const updateResponseCount = createAction(SUBSCRIPTION_RESPONSE_COUNT_UPDATE);
