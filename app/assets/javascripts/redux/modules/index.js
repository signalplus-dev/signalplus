import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as form } from 'redux-form';
import { reducer as app } from 'redux/modules/app.js';
import models from 'redux/modules/models/index.js';


export default combineReducers({
  routing: routerReducer,
  app,
  models,
  form,
});
