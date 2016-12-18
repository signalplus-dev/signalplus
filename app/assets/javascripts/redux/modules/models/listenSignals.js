import _ from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from 'redux/utils.js';
import Endpoints, { listenSignalEndpoint } from 'util/endpoints.js';
import {
  normalizeListenSignalsResponse,
  normalizeListenSignalResponse,
} from 'util/normalize.js';
import { PROMOTION_SIGNAL_POST_REQUEST_SUCCESS } from 'redux/modules/models/promotionalTweets.js';


/*
* Action Type Constants
*/
export const LISTEN_SIGNALS_REQUEST = 'signalplus/listenSignals/REQUEST';
export const LISTEN_SIGNALS_REQUEST_SUCCESS = 'signalplus/listenSignals/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_REQUEST_FAIL = 'signalplus/listenSignals/REQUEST_FAIL';

export const LISTEN_SIGNAL_SHOW_REQUEST = 'signalplus/listenSignals/show/REQUEST';
export const LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS = 'signalplus/listenSignals/show/REQUEST_SUCCESS';
export const LISTEN_SIGNAL_SHOW_REQUEST_FAIL = 'signalplus/listenSignals/show/REQUEST_FAIL';

export const LISTEN_SIGNALS_UPDATE_REQUEST = 'signalplus/listenSignals/update/REQUEST';
export const LISTEN_SIGNALS_UPDATE_REQUEST_SUCCESS = 'signalplus/listenSignals/update/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_UPDATE_REQUEST_FAIL = 'signalplus/listenSignals/update/REQUEST_FAIL';

export const LISTEN_SIGNALS_CREATE_REQUEST = 'signalplus/listenSignals/create/REQUEST';
export const LISTEN_SIGNALS_CREATE_REQUEST_SUCCESS = 'signalplus/listenSignals/create/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_CREATE_REQUEST_FAIL = 'signalplus/listenSignals/create/REQUEST_FAIL';

export const LISTEN_SIGNALS_DELETE_REQUEST = 'signalplus/listenSignals/delete/REQUEST';
export const LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS = 'signalplus/listenSignals/delete/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_DELETE_REQUEST_FAIL = 'signalplus/listenSignals/delete/REQUEST_FAIL';


/*
* Initial State
*/
const initialState = {
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

  [LISTEN_SIGNALS_CREATE_REQUEST]: handleSignalRequest,

  [LISTEN_SIGNALS_CREATE_REQUEST_SUCCESS]: handlesListenSignalSucccesResponse,

  // TBD, need to use flash reducer here on failure
  // [LISTEN_SIGNALS_CREATE_REQUEST_FAIL]: handlesListenSignalFailResponse,

  [LISTEN_SIGNALS_UPDATE_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
    loaded: false,
  }),

  [LISTEN_SIGNALS_UPDATE_REQUEST_SUCCESS]: handlesListenSignalSucccesResponse,

  [LISTEN_SIGNALS_UPDATE_REQUEST_FAIL]: handlesListenSignalFailResponse,

  [LISTEN_SIGNALS_DELETE_REQUEST]: (state, action) => ({
    ...state,
  }),

  [LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS]: (state, action) => {
    return {
      ...state,
      data: {
        ..._.omit(state.data, action.meta.signal.id),
      },
    };
  },

  [LISTEN_SIGNALS_DELETE_REQUEST_FAIL]: (state, action) => ({
    ...state,
    data: {
      [action.meta.signal.id]: {
        ..._.get(state, `data.${action.meta.signal.id}`, {}),
        error: action.payload,
      },
    },
  }),


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
          promotional_tweets: _.get(state, `data.${signalId}.promotional_tweets`, []).concat(id),
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
      LISTEN_SIGNALS_CREATE_REQUEST,
      LISTEN_SIGNALS_CREATE_REQUEST_SUCCESS,
      LISTEN_SIGNALS_CREATE_REQUEST_FAIL,
    ],
  });
};

export const updateListenSignalData = (payload, id, requestMethod = 'PUT') => {
  return createRequestAction({
    endpoint: listenSignalEndpoint(id),
    method: requestMethod,
    body: JSON.stringify(payload),
    types: [
      { type: LISTEN_SIGNALS_UPDATE_REQUEST, meta: { id } },
      { type: LISTEN_SIGNALS_UPDATE_REQUEST_SUCCESS, meta: { id } },
      { type: LISTEN_SIGNALS_UPDATE_REQUEST_FAIL, meta: { id } },
    ],
  });
};

export const deleteListenSignalData = (signal) => {
  return createRequestAction({
    endpoint: listenSignalEndpoint(signal.id),
    method: 'DELETE',
    types: [
      { type: LISTEN_SIGNALS_DELETE_REQUEST, meta: { signal } },
      { type: LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS, meta: { signal } },
      { type: LISTEN_SIGNALS_DELETE_REQUEST_FAIL, meta: { signal } },
    ],
  });
};
