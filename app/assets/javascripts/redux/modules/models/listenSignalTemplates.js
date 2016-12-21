import { get } from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction, getDataFor } from 'redux/utils';
import Endpoints from 'util/endpoints';

/*
* Action Type Constants
*/
export const LISTEN_SIGNAL_TEMPLATES_REQUEST = 'signalplus/listenSignalTemplates/REQUEST';
export const LISTEN_SIGNAL_TEMPLATES_REQUEST_SUCCESS = 'signalplus/listenSignalTemplates/REQUEST_SUCCESS';
export const LISTEN_SIGNAL_TEMPLATES_REQUEST_FAIL = 'signalplus/listenSignalTemplates/REQUEST_FAIL';


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
  [LISTEN_SIGNAL_TEMPLATES_REQUEST]: (state, action) => ({
    ...state,
    loading: true,
  }),

  [LISTEN_SIGNAL_TEMPLATES_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: get(action.payload, 'templates', {}),
    loading: false,
    loaded: true,
  }),

  [LISTEN_SIGNAL_TEMPLATES_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),
}, initialState);

const fetchListenSignalTemplatesData = () => {
  return createRequestAction({
    endpoint: Endpoints.LISTEN_SIGNAL_TEMPLATES,
    types: [
      LISTEN_SIGNAL_TEMPLATES_REQUEST,
      { type: LISTEN_SIGNAL_TEMPLATES_REQUEST_SUCCESS },
      LISTEN_SIGNAL_TEMPLATES_REQUEST_FAIL,
    ],
  });
};

export function getListenSignalTemplatesData() {
  return getDataFor(
    'listenSignalTemplates',
    fetchListenSignalTemplatesData
  );
}
