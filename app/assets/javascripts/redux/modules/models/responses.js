import { get } from 'lodash';
import { handleActions } from 'redux-actions';
import { normalizeListenSignalsResponse } from '../../../util/normalize.js';
import {
  LISTEN_SIGNALS_REQUEST,
  LISTEN_SIGNALS_REQUEST_SUCCESS,
  LISTEN_SIGNALS_REQUEST_FAIL,
} from './listenSignals.js';


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
  [LISTEN_SIGNALS_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
  }),

  [LISTEN_SIGNALS_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: get(normalizeListenSignalsResponse(action.payload), 'entities.responses', {}),
    loading: false,
    loaded: true,
  }),

  [LISTEN_SIGNALS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),
}, initialState);
