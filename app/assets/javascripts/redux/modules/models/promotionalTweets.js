import _ from 'lodash';
import { handleActions } from 'redux-actions';
import { normalizeListenSignalsResponse } from '../../../util/normalize.js';
import Endpoints from '../../../util/endpoints.js';
import {
  LISTEN_SIGNALS_REQUEST,
  LISTEN_SIGNALS_REQUEST_SUCCESS,
  LISTEN_SIGNALS_REQUEST_FAIL,
} from './listenSignals.js';


const PROMOTION_SIGNAL_POST_REQUEST = 'signalplus/promotionalSignal/REQUEST';
const PROMOTION_SIGNAL_POST_REQUEST_SUCCESS = 'signalplus/promotionalSignal/REQUEST_SUCESS';
const PROMOTION_SIGNAL_POST_REQUEST_FAIL = 'signalplus/promotionalSignal/REQUEST_FAIL';

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
    data: _.get(normalizeListenSignalsResponse(action.payload), 'entities.promotionalTweet', {}),
    loading: false,
    loaded: true,
  }),

  [LISTEN_SIGNALS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),

  [PROMOTION_SIGNAL_POST_REQUEST]: (state, action) => ({
    ...state,
    data: _.get(normalizedListenSignalResponse(action.payload), 'entities.promotionalTweet', {}),
    loading: false,
    loaded: true,
  }),

  [PROMOTION_SIGNAL_POST_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: _.get(normalizedListenSignalResponse(action.payload), 'entities.promotionalTweet', {}),
    loading: false,
    loaded: true,
  }),

  [PROMOTION_SIGNAL_POST_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: true,
  }),
}, initialState);

export const addPromotionalTweetData = (payload) => {
  return createRequestAction({
    endpoint: Endpoints.PROMOTIONAL_SIGNAL_INDEX,
    method: 'POST',
    body: JSON.stringify(payload),
    types: [
      PROMOTION_SIGNAL_POST_REQUEST,
      PROMOTION_SIGNAL_POST_REQUEST_SUCCESS,
      PROMOTION_SIGNAL_POST_REQUEST_FAIL,
    ],
  })
}
