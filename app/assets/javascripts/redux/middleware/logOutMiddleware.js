import { logOut } from 'redux/modules/app/authentication';
import { isRequestActionUnauthorized } from 'util/authentication';

export default store => next => (action) => {
  if (isRequestActionUnauthorized(action)) {
    if (process.env.RAILS_ENV === 'development') {
      debugger;
    }
    store.dispatch(logOut);
  }

  return next(action);
}
