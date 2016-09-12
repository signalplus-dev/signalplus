import { combineReducers } from 'redux';
import { reducer as app } from './app.js';
import models from './models/index.js';


export default combineReducers({
  app,
  models,
});
