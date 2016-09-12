import { handleActions } from 'redux-actions';
import { createRequestAction } from '../../utils.js';
import Endpoints from '../../../util/endpoints.js';
import { normalizeBrand } from '../../../util/normalize.js';

/*
* Action Type Constants
*/
export const BRAND_REQUEST = 'signalplus/brand/REQUEST';
export const BRAND_REQUEST_SUCCESS = 'signalplus/brand/REQUEST_SUCCESS';
export const BRAND_REQUEST_FAIL = 'signalplus/brand/REQUEST_FAIL';


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
  [BRAND_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
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
}, initialState);

export const fetchBrandData = (brandId) => {
  return createRequestAction({
    endpoint: Endpoints.BRAND,
    types: [
      { type: BRAND_REQUEST, meta: { brandId } },
      { type: BRAND_REQUEST_SUCCESS, meta: { brandId } },
      { type: BRAND_REQUEST_FAIL, meta: { brandId } },
    ],
  });
};
