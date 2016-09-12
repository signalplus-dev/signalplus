import { createAction, handleActions } from 'redux-actions';

/*
* Action Type Constants
*/
export const AUTHENTICATED = 'signalplus/app/AUTHENTICATED';


export const SIGNALS_TAB_ID = 'signals';
export const TEMPLATE_TAB_ID = 'template';

/*
* Initial State
*/
export const initialState = {
  authenticated: false,
  dashboard: {
    tabs: [
      {
        id: SIGNALS_TAB_ID,
        label: 'SIGNALS',
      },
      {
        id: TEMPLATE_TAB_ID,
        label: 'CREATE NEW',
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
}, initialState);

/*
* Action Creators
*/
const authenticated = createAction(AUTHENTICATED)

export const actions = {
  authenticated,
};
