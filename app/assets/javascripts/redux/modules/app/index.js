import { createAction, handleActions } from 'redux-actions';
import { combineReducers } from 'redux';
import { createChannelSubscriptions, subscribeToChannels } from 'redux/actionCableSubscriptions.js'
import { AUTHENTICATED, authenticate } from 'redux/modules/app/authentication.js';
import _ from 'lodash';

/*
* Action Type Constants
*/
const ADD_TAB = 'signalplus/app/dashboard/tab/ADD_TAB';
const REMOVE_TAB = 'signalplus/app/dashboard/tab/REMOVE_TAB';
const REPLACE_TAB = 'signalplus/app/dashboard/tab/REPLACE_TAB';
const SUBSCRIBED_TO_CHANNELS = 'signalplus/app/SUBSCRIBED_TO_CHANNELS';

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

}, initialState);

/*
* Action Creators
*/
const addTab = createAction(ADD_TAB);
const removeTab = createAction(REMOVE_TAB);
const replaceTab = createAction(REPLACE_TAB);
const subscribedToChannels = createAction(SUBSCRIBED_TO_CHANNELS);

/**
  * Create a thunk that conditionally subscribes to channels if we haven't already subscribed
  */
const subscribeToChannelsAction = () => (dispatch, getState) => {
  const state = getState();
  if (!state.app.subscribedToChannels) {
    const subscriptionConfig = {
      brand_id: state.models.brand.data.id
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
};
