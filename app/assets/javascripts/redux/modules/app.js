import { createAction, handleActions } from 'redux-actions';

/*
* Action Type Constants
*/
export const AUTHENTICATED = 'signalplus/brand/AUTHENTICATED';


/*
* Initial State
*/
export const initialState = {
  authenticated: false,
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
