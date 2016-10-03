import _ from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from 'redux/utils.js';
import Endpoints, { listenSignalEndpoint } from 'util/endpoints.js';
import {
  normalizeListenSignalsResponse,
  normalizeListenSignalResponse,
} from 'util/normalize.js';
import { PROMOTION_SIGNAL_POST_REQUEST_SUCCESS } from './promotionalTweets.js';
import { 
  PROMOTION_SIGNAL_POST_REQUEST_SUCCESS
 } from './promotionalTweets.js';

/*
* Action Type Constants
*/
export const LISTEN_SIGNALS_REQUEST = 'signalplus/listenSignals/REQUEST';
export const LISTEN_SIGNALS_REQUEST_SUCCESS = 'signalplus/listenSignals/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_REQUEST_FAIL = 'signalplus/listenSignals/REQUEST_FAIL';

export const LISTEN_SIGNAL_SHOW_REQUEST = 'signalplus/listenSignals/SHOW_REQUEST';
export const LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS = 'signalplus/listenSignals/SHOW_REQUEST_SUCCESS';
export const LISTEN_SIGNAL_SHOW_REQUEST_FAIL = 'signalplus/listenSignals/SHOW_REQUEST_FAIL';

export const LISTEN_SIGNALS_PUT_REQUEST = 'signalplus/listenSignals/put/REQUEST';
export const LISTEN_SIGNALS_PUT_REQUEST_SUCCESS = 'signalplus/listenSignals/put/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_PUT_REQUEST_FAIL = 'signalplus/listenSignals/put/REQUEST_FAIL';

export const LISTEN_SIGNALS_POST_REQUEST = 'signalplus/listenSignals/post/REQUEST';
export const LISTEN_SIGNALS_POST_REQUEST_SUCCESS = 'signalplus/listenSignals/post/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_POST_REQUEST_FAIL = 'signalplus/listenSignals/post/REQUEST_FAIL';


/*
* Initial State
*/
export const initialState = {
  data: {},
  loaded: false,
  loading: false,
};

function handleSignalRequest(state, action) {
  return {
    ...state,
    loading: true,
    loaded: false,
  }
}

function handlesListenSignalSucccesResponse(state, action) {
  const normalizedResponse = normalizeListenSignalResponse(action.payload);
  const listenSignalResponse = _.get(normalizedResponse, 'entities.listenSignal', {});
  const id = _.findLastKey(listenSignalResponse);
  const listenSignal = listenSignalResponse[id];

  return {
    ...state,
    data: {
      ..._.get(state, 'data', {}),
      [id]: {
        ..._.get(state, `data.${id}`, {}),
        ...listenSignal,
        loading: false,
        loaded: true,
      },
    },
  };
}

function handlesListenSignalFailResponse(state, action) {
  return {
    ...state,
    data: {
      ..._.get(state, 'data', {}),
      [action.meta.id]: {
        ..._.get(state, `data.${action.meta.id}`, {}),
        error: action.payload,
        loading: false,
        loaded: false,
      },
    },
  };
}

/*
* Reducer
*/
export const reducer = handleActions({
  [LISTEN_SIGNALS_REQUEST]: handleSignalRequest,

  [LISTEN_SIGNALS_REQUEST_SUCCESS]: (state, action) => {
    const signals = _.get(normalizeListenSignalsResponse(action.payload), 'entities.listenSignals', {});

    return {
      ...state,
      data: _.reduce(signals, (currentSignals, signal, id) => ({
        ...currentSignals,
        [id]: {
          ...signal,
          loading: false,
          loaded: true,
        },
      }), {}),
    };
  },

  [LISTEN_SIGNALS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),

  [LISTEN_SIGNAL_SHOW_REQUEST]: (state, action) => ({
    ...state,
    data: {
      ..._.get(state, 'data', {}),
      [action.meta.id]: {
        ...state[action.meta.id],
        loading: true,
      },
    },
  }),

  [LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS]: handlesListenSignalSucccesResponse,

  [LISTEN_SIGNAL_SHOW_REQUEST_FAIL]: handlesListenSignalFailResponse,

  [LISTEN_SIGNALS_POST_REQUEST]: handleSignalRequest,

  [LISTEN_SIGNALS_POST_REQUEST_SUCCESS]: handlesListenSignalSucccesResponse,

  // TBD, need to use flash reducer here on failure
  // [LISTEN_SIGNALS_POST_REQUEST_FAIL]: handlesListenSignalFailResponse,

  [LISTEN_SIGNALS_PUT_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
  }),

  [LISTEN_SIGNALS_PUT_REQUEST_SUCCESS]: handlesListenSignalSucccesResponse,

  [LISTEN_SIGNALS_PUT_REQUEST_FAIL]: handlesListenSignalFailResponse,

  [PROMOTION_SIGNAL_POST_REQUEST_SUCCESS]: (state, action) => {
    const promotionalTweet = _.get(action.payload, 'promotional_tweet', {});
    const id = promotionalTweet.id;
    const signalId = promotionalTweet.listen_signal_id;

    return {
      ...state,
      data: {
        ...state.data,
        [signalId]: {
          ..._.get(state, `data.${signalId}`, {}),
          promotionalTweets: _.get(state, `data.${signalId}.promotionalTweets`, []).concat(id),
        },
      },
    };
  },

}, initialState);

const fetchListenSignalsData = () => {
  return createRequestAction({
    endpoint: Endpoints.LISTEN_SIGNALS_INDEX,
    types: [
      LISTEN_SIGNALS_REQUEST,
      LISTEN_SIGNALS_REQUEST_SUCCESS,
      LISTEN_SIGNALS_REQUEST_FAIL,
    ],
  });
};

const fetchListenSignalData = (id) => () => {
  return createRequestAction({
    endpoint: listenSignalEndpoint(id),
    types: [
      { type: LISTEN_SIGNAL_SHOW_REQUEST, meta: { id } },
      { type: LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS, meta: { id } },
      { type: LISTEN_SIGNAL_SHOW_REQUEST_FAIL, meta: { id } },
    ]
  });
};

export function getListenSignalsData() {
  return getDataFor(
    'listenSignals',
    fetchListenSignalsData
  );
}

export function getListenSignalData(listenSignalId) {
  return getDataFor(
    `listenSignals.data.${listenSignalId}`,
    fetchListenSignalData(listenSignalId)
  );
}

export const addListenSignalData = (payload) => {
  return createRequestAction({
    endpoint: Endpoints.LISTEN_SIGNALS_INDEX,
    method: 'POST',
    body: JSON.stringify(payload),
    types: [
      LISTEN_SIGNALS_POST_REQUEST,
      LISTEN_SIGNALS_POST_REQUEST_SUCCESS,
      LISTEN_SIGNALS_POST_REQUEST_FAIL,
    ],
  });
};

export const updateListenSignalData = (payload, id) => {
  return createRequestAction({
    endpoint: listenSignalEndpoint(id),
    method: 'PUT',
    body: JSON.stringify(payload),
    types: [
      { type: LISTEN_SIGNALS_PUT_REQUEST, meta: { id } },
      { type: LISTEN_SIGNALS_PUT_REQUEST_SUCCESS, meta: { id } },
      { type: LISTEN_SIGNALS_PUT_REQUEST_FAIL, meta: { id } },
    ],
  });
};
