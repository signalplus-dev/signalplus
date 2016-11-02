import { get } from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from 'redux/utils.js';
import { normalizeInvoicesResponse } from 'util/normalize.js';
import Endpoints from 'util/endpoints.js';

/*
* Action Type Constants
*/
export const INVOICES_REQUEST = 'signalplus/invoices/REQUEST';
export const INVOICES_REQUEST_SUCCESS = 'signalplus/invoices/REQUEST_SUCCESS';
export const INVOICES_REQUEST_FAIL = 'signalplus/invoices/REQUEST_FAIL';

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
  [INVOICES_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
  }),

  [INVOICES_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: get(normalizeInvoicesResponse(action.payload), 'entities.invoices', {}),
    loading: false,
    loaded: true,
  }),

  [INVOICES_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),
}, initialState);


export function fetchInvoicesData() {
  return createRequestAction({
    endpoint: Endpoints.INVOICES,
    types: [
      INVOICES_REQUEST,
      INVOICES_REQUEST_SUCCESS,
      INVOICES_REQUEST_FAIL,
    ],
  });
};

export function getInvoicesData() {
  return getDataFor(
    'invoices',
    fetchInvoicesData
  );
};
