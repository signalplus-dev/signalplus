import { combineReducers } from 'redux';
import { reducer as app } from './app.js';
import { reducer as brand } from './brand.js';
import { reducer as subscription } from './subscription.js';


export default combineReducers({
  app,
  brand,
  subscription,
});
