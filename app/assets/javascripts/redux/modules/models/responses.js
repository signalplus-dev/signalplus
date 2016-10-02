import _ from 'lodash';
import { handleActions } from 'redux-actions';
import {
  normalizeListenSignalsResponse,
  normalizeListenSignalResponse,
} from 'util/normalize.js';
import {
  LISTEN_SIGNALS_REQUEST,
  LISTEN_SIGNALS_REQUEST_SUCCESS,
  LISTEN_SIGNALS_REQUEST_FAIL,
  LISTEN_SIGNALS_PUT_REQUEST,
  LISTEN_SIGNALS_PUT_REQUEST_SUCCESS,
  LISTEN_SIGNALS_PUT_REQUEST_FAIL,
  LISTEN_SIGNALS_POST_REQUEST,
  LISTEN_SIGNALS_POST_REQUEST_SUCCESS,
  LISTEN_SIGNALS_POST_REQUEST_FAIL,
} from 'redux/modules/models/listenSignals.js';


/*
* Initial State
*/
export const initialState = {
  data: {},
  loaded: false,
  loading: false,
};

function handleResponseRequest(state, action) {
  const normalizedResponse = normalizeListenSignalResponse(action.payload);
  const responses = _.get(normalizedResponse, 'entities.responses', {});

  return {
    ...state,
    data: {
      ..._.get(state, 'data', {}),
      ...responses,
    }
  };
}

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
    data: _.get(normalizeListenSignalsResponse(action.payload), 'entities.responses', {}),
    loading: false,
    loaded: true,
  }),

  [LISTEN_SIGNALS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),

  [LISTEN_SIGNALS_PUT_REQUEST_SUCCESS]: handleResponseRequest,

  [LISTEN_SIGNALS_POST_REQUEST_SUCCESS]: handleResponseRequest,

}, initialState);
