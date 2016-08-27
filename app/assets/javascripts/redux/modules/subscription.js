import { handleActions } from 'redux-actions';
import { normalizeSubscription } from '../../util/normalize.js';
import {
  BRAND_REQUEST,
  BRAND_REQUEST_SUCCESS,
  BRAND_REQUEST_FAIL,
} from './brand.js';


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
    ...normalizeSubscription(action.payload),
  }),

  [BRAND_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),
}, initialState);
