import { get } from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from '../../utils.js';
import Endpoints from '../../../util/endpoints.js';
import { normalizeSubscriptionPlansResponse } from '../../../util/normalize.js';

/*
* Action Type Constants
*/
export const SUBSCRIPTION_PLANS_REQUEST = 'signalplus/subscriptionPlans/REQUEST';
export const SUBSCRIPTION_PLANS_REQUEST_SUCCESS = 'signalplus/subscriptionPlans/REQUEST_SUCCESS';
export const SUBSCRIPTION_PLANS_REQUEST_FAIL = 'signalplus/subscriptionPlans/REQUEST_FAIL';


/*
* Initial State
*/
export const initialState = {
  data: {},
  loaded: false,
  loading: false,
};

/*
* Reducer
*/
export const reducer = handleActions({
  [SUBSCRIPTION_PLANS_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
  }),

  [SUBSCRIPTION_PLANS_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: get(normalizeSubscriptionPlansResponse(action.payload), 'entities.subscriptionPlans', {}),
    loading: false,
    loaded: true,
  }),

  [SUBSCRIPTION_PLANS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),
}, initialState);

export function fetchSubscriptionPlansData() {
  return createRequestAction({
    endpoint: Endpoints.SUBSCRIPTION_PLANS,
    types: [
      SUBSCRIPTION_PLANS_REQUEST,
      SUBSCRIPTION_PLANS_REQUEST_SUCCESS,
      SUBSCRIPTION_PLANS_REQUEST_FAIL,
    ],
  });
};

export function getSubscriptionPlansData() {
  return getDataFor(
    'subscriptionPlans',
    fetchSubscriptionPlansData
  );
}
