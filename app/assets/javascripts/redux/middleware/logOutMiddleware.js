import { logOut } from 'redux/modules/app/authentication';

export default store => next => (action) => {
  if (action.payload && action.payload.constructor.name === 'ApiError') {
    if (action.payload.status === 401) {
      store.dispatch(logOut);
    }
  }

  return next(action);
}
