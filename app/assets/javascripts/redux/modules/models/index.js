import { combineReducers } from 'redux';
import { reducer as brand } from './brand.js';
import { reducer as subscription } from './subscription.js';
import { reducer as listenSignals } from './listenSignals.js';
import { reducer as responses } from './responses.js';
import { reducer as promotionalTweets } from './promotionalTweets.js';


export default combineReducers({
  brand,
  subscription,
  listenSignals,
  responses,
  promotionalTweets,
});
