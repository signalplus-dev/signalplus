import _ from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from '../../utils.js';
import Endpoints, { listenSignalEndpoint } from '../../../util/endpoints.js';
import {
  normalizeListenSignalsResponse,
  normalizeListenSignalResponse,
} from '../../../util/normalize.js';

/*
* Action Type Constants
*/
export const LISTEN_SIGNALS_REQUEST = 'signalplus/listenSignals/REQUEST';
export const LISTEN_SIGNALS_REQUEST_SUCCESS = 'signalplus/listenSignals/REQUEST_SUCCESS';
export const LISTEN_SIGNALS_REQUEST_FAIL = 'signalplus/listenSignals/REQUEST_FAIL';

export const LISTEN_SIGNAL_SHOW_REQUEST = 'signalplus/listenSignals/SHOW_REQUEST';
export const LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS = 'signalplus/listenSignals/SHOW_REQUEST_SUCCESS';
export const LISTEN_SIGNAL_SHOW_REQUEST_FAIL = 'signalplus/listenSignals/SHOW_REQUEST_FAIL';


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
    [action.meta.id]: {
      ...state[action.meta.id],
      loading: true,
    },
  }),

  [LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    [action.meta.id]: {
      ...state[action.meta.id],
      data: _.get(normalizeListenSignalResponse(action.payload), 'entities.listenSignal', {}),
      loading: false,
      loaded: true,
    },
  }),

  [LISTEN_SIGNAL_SHOW_REQUEST_FAIL]: (state, action) => ({
    ...state,
    [action.meta.id]: {
      ...state[action.meta.id],
      error: action.payload,
      loading: false,
      loaded: false,
    },
  }),
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
