import _ from 'lodash';
import { actions as appActions } from 'redux/modules/app/index';
import {
  LISTEN_SIGNALS_REQUEST_FAIL,
  LISTEN_SIGNALS_UPDATE_REQUEST_SUCCESS,
  LISTEN_SIGNALS_CREATE_REQUEST_SUCCESS,
  LISTEN_SIGNALS_CREATE_REQUEST_FAIL,
  LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS,
} from 'redux/modules/models/listenSignals';

import {
  PROMOTION_SIGNAL_POST_REQUEST_SUCCESS,
  PROMOTION_SIGNAL_POST_REQUEST_FAIL,
} from 'redux/modules/models/promotionalTweets';

import {
  SUBSCRIPTION_CREATE_REQUEST_SUCCESS,
  SUBSCRIPTION_CREATE_REQUEST_FAIL,
  SUBSCRIPTION_UPDATE_REQUEST_SUCCESS,
  SUBSCRIPTION_UPDATE_REQUEST_FAIL,
  SUBSCRIPTION_CANCEL_REQUEST_SUCCESS,
  SUBSCRIPTION_CANCEL_REQUEST_FAIL,
} from 'redux/modules/models/subscription';

export const FLASH_MESSAGE_INFO = 'info';
export const FLASH_MESSAGE_SUCCESS = 'success';
export const FLASH_MESSAGE_ERROR = 'error';

const flashMessages = {
  [LISTEN_SIGNALS_REQUEST_FAIL]: () => {
    return {
      type: FLASH_MESSAGE_ERROR,
      message: 'Sorry, we had trouble fetching your signals.',
    };
  },

  [LISTEN_SIGNALS_UPDATE_REQUEST_SUCCESS]: (payload, meta) => {
    const signalName = _.get(payload, 'listen_signal.name');

    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: `Your #${signalName} signal has been successfully updated.`,
    };
  },

  [LISTEN_SIGNALS_CREATE_REQUEST_SUCCESS]: (payload, meta) => {
    const signalName = _.get(payload, 'listen_signal.name');

    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: `Your #${signalName} signal has been successfully created.`,
    };
  },

  [LISTEN_SIGNALS_CREATE_REQUEST_FAIL]: () => {
    return {
      type: FLASH_MESSAGE_ERROR,
      message: 'Sorry, we had trouble creating your signal.',
    };
  },

  [LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS]: (payload, meta) => {
    const signalName = _.get(meta, 'signal.name');

    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: `Your #${signalName} signal has been successfully deleted.`,
    };
  },

  [PROMOTION_SIGNAL_POST_REQUEST_SUCCESS]: (payload, meta) => {
    const tweetUrl = _.get(payload, 'promotional_tweet.tweet_url');

    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: `You can check out your promotional tweet `,
      link: tweetUrl,
    };
  },

  [PROMOTION_SIGNAL_POST_REQUEST_FAIL]: () => {
    return {
      type: FLASH_MESSAGE_ERROR,
      message: 'Sorry, we had trouble posting your promotional tweet.',
    };
  },

  [SUBSCRIPTION_CREATE_REQUEST_SUCCESS]: () => {
    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: 'Your subscription was successfully created.',
    };
  },

  [SUBSCRIPTION_CREATE_REQUEST_FAIL]: () => {
    return {
      type: FLASH_MESSAGE_ERROR,
      message: 'Sorry, we had trouble creating your subscription.',
    };
  },

  [SUBSCRIPTION_UPDATE_REQUEST_SUCCESS]: () => {
    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: 'Your subscription was successfully updated.',
    };
  },

  [SUBSCRIPTION_UPDATE_REQUEST_FAIL]: () => {
    return {
      type: FLASH_MESSAGE_ERROR,
      message: 'Sorry, we had trouble updating your subscription.',
    };
  },


  [SUBSCRIPTION_CANCEL_REQUEST_SUCCESS]: () => {
    return {
      type: FLASH_MESSAGE_SUCCESS,
      message: 'Your subscription was successfully cancelled.',
    };
  },

  [SUBSCRIPTION_CANCEL_REQUEST_FAIL]: () => {
    return {
      type: FLASH_MESSAGE_ERROR,
      message: 'Sorry, we had trouble cancelling your subscription.',
    };
  },

};

export default store => next => (action) => {
  const flashMessage = flashMessages[action.type];

  if (flashMessage) {
    const flashMessagePayload = flashMessage(action.payload, action.meta);
    store.dispatch(appActions.renderFlashMessage(flashMessagePayload));
  }

  return next(action);
};
