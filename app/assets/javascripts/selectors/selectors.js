import { createSelector } from 'reselect';
import _ from 'lodash';

const getSubscription = state => _.get(state, 'models.subscription.data');
const getSubscriptionPlans = state =>  _.get(state, 'models.subscriptionPlans.data');

function sortByNumberOfMessages(subscriptionPlan) {
  return subscriptionPlan.number_of_messages;
}

export const isTopSubscriptionSelector = createSelector(
  [ getSubscription, getSubscriptionPlans ],
  (subscription, subscriptionPlans) => {
    if (_.isEmpty(subscriptionPlans)) return false;

    const bestSubscriptionPlan = _.last(_.sortBy(subscriptionPlans, sortByNumberOfMessages));
    return !(subscription.number_of_messages < bestSubscriptionPlan.number_of_messages);
  }
);
