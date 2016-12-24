import _ from 'lodash';
import { actions as appActions } from 'redux/modules/app/index';

export default store => next => (action) => {
  const { meta }= action;
  if (meta && _.has(meta, 'spLoading')) {
    store.dispatch(appActions.toggleLoader(meta.spLoading));
  }

  return next(action);
};
