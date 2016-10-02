import { combineReducers } from 'redux';
import { reducer as brand } from 'redux/modules/models/brand.js';
import { reducer as subscription } from 'redux/modules/models/subscription.js';
import { reducer as subscriptionPlans } from 'redux/modules/models/subscriptionPlans.js';
import { reducer as listenSignals } from 'redux/modules/models/listenSignals.js';
import { reducer as listenSignalTemplates } from 'redux/modules/models/listenSignalTemplates.js';
import { reducer as responses } from 'redux/modules/models/responses.js';
import { reducer as promotionalTweets } from 'redux/modules/models/promotionalTweets.js';


export default combineReducers({
  brand,
  subscription,
  subscriptionPlans,
  listenSignals,
  listenSignalTemplates,
  responses,
  promotionalTweets,
});
