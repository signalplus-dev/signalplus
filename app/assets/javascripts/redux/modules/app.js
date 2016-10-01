import { createAction, handleActions } from 'redux-actions';
import _ from 'lodash';

/*
* Action Type Constants
*/
export const AUTHENTICATED = 'signalplus/app/AUTHENTICATED';

export const ADD_TAB = 'signalplus/app/dashboard/tab/ADD_TAB';
export const REMOVE_TAB = 'signalplus/app/dashboard/tab/REMOVE_TAB';
export const REPLACE_TAB = 'signalplus/app/dashboard/tab/REPLACE_TAB';

export const SIGNALS_TAB_ID = 'signals';
export const TEMPLATE_TAB_ID = 'templates';

/*
* Initial State
*/
const initialState = {
  authenticated: false,
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
    authenticated: true
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
const authenticated = createAction(AUTHENTICATED)
const addTab = createAction(ADD_TAB);
const removeTab = createAction(REMOVE_TAB);
const replaceTab = createAction(REPLACE_TAB);

export const actions = {
  authenticated,
  addTab,
  removeTab,
  replaceTab,
};
