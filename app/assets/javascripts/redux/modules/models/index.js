import { combineReducers } from 'redux';
import { reducer as brand } from 'redux/modules/models/brand';
import { reducer as user } from 'redux/modules/models/user';
import { reducer as subscription } from 'redux/modules/models/subscription';
import { reducer as subscriptionPlans } from 'redux/modules/models/subscriptionPlans';
import { reducer as listenSignals } from 'redux/modules/models/listenSignals';
import { reducer as listenSignalTemplates } from 'redux/modules/models/listenSignalTemplates';
import { reducer as responses } from 'redux/modules/models/responses';
import { reducer as promotionalTweets } from 'redux/modules/models/promotionalTweets';
import { reducer as invoices } from 'redux/modules/models/invoices';

export default combineReducers({
  brand,
  user,
  subscription,
  subscriptionPlans,
  listenSignals,
  listenSignalTemplates,
  responses,
  promotionalTweets,
  invoices,
});
