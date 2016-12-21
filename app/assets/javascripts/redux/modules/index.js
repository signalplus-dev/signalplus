import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as form } from 'redux-form';
import { reducer as app } from 'redux/modules/app/index';
import models from 'redux/modules/models/index';


export default combineReducers({
  routing: routerReducer,
  app,
  models,
  form,
});
