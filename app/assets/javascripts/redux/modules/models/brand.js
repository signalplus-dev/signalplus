import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from 'redux/utils.js';
import _ from 'lodash';
import Endpoints from 'util/endpoints.js';
import { normalizeBrand } from 'util/normalize.js';
import { USER_UPDATE_REQUEST_SUCCESS } from 'redux/modules/models/user.js'

/*
* Action Type Constants
*/
export const BRAND_REQUEST = 'signalplus/brand/REQUEST';
export const BRAND_REQUEST_SUCCESS = 'signalplus/brand/REQUEST_SUCCESS';
export const BRAND_REQUEST_FAIL = 'signalplus/brand/REQUEST_FAIL';

export const BRAND_INFO_POST_REQUEST = 'signalplus/brand/account_info/REQUEST';
export const BRAND_INFO_POST_REQUEST_SUCCESS = 'signalplus/brand/account_info/REQUEST_SUCESS';
export const BRAND_INFO_POST_REQUEST_FAIL = 'signalplus/brand/account_info/REQUEST_FAIL';

function extractBrandInfoFromUserResponse(payload) {
  const brandData = _.get(payload, 'entities.brand');
  return _.omit(_.first(_.values(brandData)), 'subscription');
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
  [BRAND_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
  }),

  [BRAND_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    ...normalizeBrand(action.payload),
  }),

  [BRAND_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),

  [BRAND_INFO_POST_REQUEST]: (state,action) => ({
    ...state,
  }),

  [BRAND_INFO_POST_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    ...normalizeBrand(action.payload),
  }),

  [BRAND_INFO_POST_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
  }),

  [USER_UPDATE_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: {
      ...state.data,
      ...extractBrandInfoFromUserResponse(action.payload),
    },
  })

}, initialState);

export const fetchBrandData = () => {
  return createRequestAction({
    endpoint: Endpoints.BRAND,
    types: [
      BRAND_REQUEST,
      BRAND_REQUEST_SUCCESS,
      BRAND_REQUEST_FAIL,
    ],
  });
}

export function getBrandData() {
  return getDataFor(
    'brand',
    fetchBrandData
  );
}

export const updateBrandAccountInfo = (payload) => {
  return createRequestAction({
    endpoint: Endpoints.BRAND_ACCOUNT_INFO,
    method: 'POST',
    body: JSON.stringify(payload),
    types: [
      BRAND_INFO_POST_REQUEST,
      BRAND_INFO_POST_REQUEST_SUCCESS,
      BRAND_INFO_POST_REQUEST_FAIL,
    ],
  });
}
