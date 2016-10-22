import _ from 'lodash';
import { actions as appActions } from 'redux/modules/app/index.js';
import {
  LISTEN_SIGNALS_REQUEST_FAIL,
  LISTEN_SIGNALS_UPDATE_REQUEST_SUCCESS,
  LISTEN_SIGNALS_CREATE_REQUEST_SUCCESS,
  LISTEN_SIGNALS_CREATE_REQUEST_FAIL,
  LISTEN_SIGNALS_DELETE_REQUEST_SUCCESS,
} from 'redux/modules/models/listenSignals.js';

export const FLASH_MESSAGE_INFO = 'info';
const FLASH_MESSAGE_SUCCESS = 'success';
const FLASH_MESSAGE_ERROR = 'error';

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

};

export default store => next => (action) => {
  const flashMessage = flashMessages[action.type];

  if (flashMessage) {
    const flashMessagePayload = flashMessage(action.payload, action.meta);
    store.dispatch(appActions.renderFlashMessage(flashMessagePayload));
  }

  next(action);
};
