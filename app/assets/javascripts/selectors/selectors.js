import { createSelector } from 'reselect';
import _ from 'lodash';
import moment from 'moment';

const getSubscription = state => _.get(state, 'models.subscription.data');
const getSubscriptionPlans = state =>  _.get(state, 'models.subscriptionPlans.data');
const getInvoices = state => _.get(state, 'models.invoices.data');

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

export const sortedInvoices = createSelector(
  [ getInvoices ], (invoices) => {
    return _.sortBy(invoices, (invoice) => {
      return -1 * moment(invoice.period_start).unix();
    });
  }
);
