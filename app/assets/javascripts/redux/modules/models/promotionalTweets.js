import _ from 'lodash';
import { handleActions } from 'redux-actions';
import { createRequestAction} from 'redux/utils.js';
import Endpoints from 'util/endpoints.js';
import {
  LISTEN_SIGNALS_REQUEST,
  LISTEN_SIGNALS_REQUEST_SUCCESS,
  LISTEN_SIGNALS_REQUEST_FAIL,
} from 'redux/modules/models/listenSignals.js';
import {
  normalizeListenSignalsResponse,
  normalizeListenSignalResponse,
} from 'util/normalize.js';

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
    };
  },

  [LISTEN_SIGNALS_REQUEST_FAIL]: (state, action) => ({
    ...state,
    error: action.payload,
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
