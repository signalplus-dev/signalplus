import { createAction, handleActions } from 'redux-actions';
import { combineReducers } from 'redux';
import { createChannelSubscriptions, subscribeToChannels } from 'redux/actionCableSubscriptions.js'
import { AUTHENTICATED, authenticate } from 'redux/modules/app/authentication.js';
import { FLASH_MESSAGE_INFO } from 'redux/middleware/flashMiddleware.js';
import _ from 'lodash';

/*
* Action Type Constants
*/
const ADD_TAB = 'signalplus/app/dashboard/tab/ADD_TAB';
const REMOVE_TAB = 'signalplus/app/dashboard/tab/REMOVE_TAB';
const REPLACE_TAB = 'signalplus/app/dashboard/tab/REPLACE_TAB';
const SUBSCRIBED_TO_CHANNELS = 'signalplus/app/SUBSCRIBED_TO_CHANNELS';
const SET_FLASH_MESSAGE = 'signalplus/app/SET_FLASH_MESSAGE';
const DISMISS_FLASH_MESSAGE = 'signalplus/app/DISMISS_FLASH_MESSAGE';
const RENDER_FLASH_MESSAGE = 'signalplus/app/RENDER_FLASH_MESSAGE';
const SHOW_MODAL = 'signalplus/app/SHOW_MODAL';
const HIDE_MODAL = 'signalplus/app/HIDE_MODAL';

export const SIGNALS_TAB_ID = 'signals';
export const TEMPLATE_TAB_ID = 'templates';

/*
* Initial State
*/
const initialState = {
  authenticated: false,
  subscribedToChannels: false,
  dashboard: {
    tabs: [
      {
        id: SIGNALS_TAB_ID,
        label: 'SIGNALS',
        link: '/dashboard/signals/active',
        closeable: false,
      },
      {
        id: TEMPLATE_TAB_ID,
        label: 'CREATE NEW',
        link: '/dashboard/templates',
        closeable: false,
      },
    ],
  },
  flashMessage: {
    type: FLASH_MESSAGE_INFO,
    message: '',
    dismissed: true,
    link: '',
  },
  modal: {
    modalType: null,
    modalProps: {},
    display: false,
  }
};

function setNewTab(tabs, payload) {
  const { tabId, newTab } = payload;

  return _.map(tabs, (tab) => {
    return tab.id === tabId ? newTab : tab;
  });
}

/*
* Reducer
*/
export const reducer = handleActions({
  [AUTHENTICATED]: (state, action) => ({
    ...state,
    authenticated: true,
  }),

  [SUBSCRIBED_TO_CHANNELS]: (state, action) => ({
    ...state,
    subscribedToChannels: true,
  }),

  [ADD_TAB]: (state, action) => ({
    ...state,
    dashboard: {
      ...state.dashboard,
      tabs: [
        ...state.dashboard.tabs,
        action.payload
      ],
    },
  }),

  [REMOVE_TAB]: (state, action) => ({
    ...state,
    dashboard: {
      ...state.dashboard,
      tabs: state.dashboard.tabs.filter(tab => tab.id !== action.payload),
    },
  }),

  [REPLACE_TAB]: (state, action) => ({
    ...state,
    dashboard: {
      ...state.dashboard,
      tabs: setNewTab(state.dashboard.tabs, action.payload),
    },
  }),

  [DISMISS_FLASH_MESSAGE]: (state, action) => ({
    ...state,
    flashMessage: {
      ...state.flashMessage,
      dismissed: true,
    },
  }),

  [RENDER_FLASH_MESSAGE]: (state, action) => ({
    ...state,
    flashMessage: {
      ...state.flashMessage,
      ...action.payload,
      dismissed: false,
    },
  }),

  [SHOW_MODAL]: (state, action) => ({
    ...state,
    modal: {
      modalType: action.payload.modalType,
      modalProps: action.payload.modalProps,
      display: true,
    },
  }),

  [HIDE_MODAL]: (state, action) => ({
    ...state,
    modal: {
      ...state.modal,
      display: false,
    },
  }),
}, initialState);

/*
* Action Creators
*/
const addTab = createAction(ADD_TAB);
const removeTab = createAction(REMOVE_TAB);
const replaceTab = createAction(REPLACE_TAB);
const subscribedToChannels = createAction(SUBSCRIBED_TO_CHANNELS);
const setFlashMessage = createAction(SET_FLASH_MESSAGE);
const dismissFlashMessage = createAction(DISMISS_FLASH_MESSAGE);
const renderFlashMessage = createAction(RENDER_FLASH_MESSAGE);
const showModal = createAction(SHOW_MODAL);
const hideModal = createAction(HIDE_MODAL);

/**
  * Create a thunk that conditionally subscribes to channels if we haven't already subscribed
  */
const subscribeToChannelsAction = () => (dispatch, getState) => {
  const state = getState();
  if (!state.app.subscribedToChannels) {
    const subscriptionConfig = {
      brand_id: state.models.brand.data.id,
    };

    const channelSubscriptions = createChannelSubscriptions(subscriptionConfig);
    subscribeToChannels(channelSubscriptions, dispatch);
    dispatch(subscribedToChannels());
  }
}

export const actions = {
  authenticate,
  addTab,
  removeTab,
  replaceTab,
  subscribeToChannelsAction,
  setFlashMessage,
  dismissFlashMessage,
  renderFlashMessage,
  showModal,
  hideModal,
};
