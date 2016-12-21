import _ from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction} from 'redux/utils';
import Endpoints from 'util/endpoints';
import {
  normalizeListenSignalsResponse,
  normalizeListenSignalResponse,
} from 'util/normalize';

// Something weird going on with imports so just going to bring these constants in
const LISTEN_SIGNALS_REQUEST = 'signalplus/listenSignals/REQUEST';
const LISTEN_SIGNALS_REQUEST_SUCCESS = 'signalplus/listenSignals/REQUEST_SUCCESS';
const LISTEN_SIGNALS_REQUEST_FAIL = 'signalplus/listenSignals/REQUEST_FAIL';

const LISTEN_SIGNAL_SHOW_REQUEST = 'signalplus/listenSignals/SHOW_REQUEST';
const LISTEN_SIGNAL_SHOW_REQUEST_SUCCESS = 'signalplus/listenSignals/SHOW_REQUEST_SUCCESS';
const LISTEN_SIGNAL_SHOW_REQUEST_FAIL = 'signalplus/listenSignals/SHOW_REQUEST_FAIL';

const LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS = 'signalplus/listenSignals/DELETE_REQUEST_SUCCESS';

export const PROMOTION_SIGNAL_POST_REQUEST = 'signalplus/promotionalSignal/REQUEST';
export const PROMOTION_SIGNAL_POST_REQUEST_SUCCESS = 'signalplus/promotionalSignal/REQUEST_SUCESS';
export const PROMOTION_SIGNAL_POST_REQUEST_FAIL = 'signalplus/promotionalSignal/REQUEST_FAIL';

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
    const promo_tweets = _.get(normalizeListenSignalsResponse(action.payload), 'entities.promotionalTweets', {});

    return {
      ...state,
      data: _.reduce(promo_tweets, (currentPromo, promo_tweet, id) => ({
        ...currentPromo,
        [id]: {
          ...promo_tweet,
        },
      }), {}),
      loading: false,
      loaded: true,
    };
  },

  [LISTEN_SIGNALS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
    loading: false,
    loaded: false,
  }),

  [LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS]: (state, action) => ({
    ...state,
    data: {
      ..._.omit(state.data, action.meta.signal.promotional_tweets),
    },
  }),

  [PROMOTION_SIGNAL_POST_REQUEST]: (state, action) => ({
    ...state,
  }),

  [PROMOTION_SIGNAL_POST_REQUEST_SUCCESS]: (state, action) => {
    const promotionalTweet = _.get(action.payload, 'promotional_tweet', {});
    const id = promotionalTweet.id;

    return {
      ...state,
      data: {
        ..._.get(state, 'data', {}),
        [id]: {
          ...promotionalTweet
        },
      },
    };
  },

  [PROMOTION_SIGNAL_POST_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
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
