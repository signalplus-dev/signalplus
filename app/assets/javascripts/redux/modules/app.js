import { createAction, handleActions } from 'redux-actions';

/*
* Action Type Constants
*/
export const AUTHENTICATED = 'signalplus/app/AUTHENTICATED';

export const ADD_TAB = 'signalplus/app/dashboard/tab/ADD_TAB';
export const REMOVE_TAB = 'signalplus/app/dashboard/tab/REMOVE_TAB';

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
      ]
    }
  }),
  [REMOVE_TAB]: (state, action) => ({
    ...state,
    dashboard: {
      ...state.dashboard,
      tabs: state.dashboard.tabs.filter(tab => tab.id !== action.payload)
    }
  }),
}, initialState);

/*
* Action Creators
*/
const authenticated = createAction(AUTHENTICATED)
const addTab = createAction(ADD_TAB);
const removeTab = createAction(REMOVE_TAB);

export const actions = {
  authenticated,
  addTab,
  removeTab,
};
