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

    const bestSubscriptionPlan = _.first(_.takeRight(_.sortBy(subscriptionPlans, sortByNumberOfMessages), 2));
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

export const subscriptionPlansSelector = createSelector(
  [ getSubscription, getSubscriptionPlans ],
  (subscription, subscriptionPlans) => {
    if (_.isEmpty(subscriptionPlans)) return [];

    const {
      subscription_plan_id,
      monthly_response_count = 0,
      admin: hasAdminPlan
    } = subscription

    return _.reduce(subscriptionPlans, (memo, subscriptionPlan) => {
      if (subscriptionPlan.reference === 'admin') return memo;

      return [
        ...memo,
        {
          ...subscriptionPlan,
          selected: subscriptionPlan.id === subscription_plan_id,
          available: (
            !hasAdminPlan && subscriptionPlan.number_of_messages >= monthly_response_count
          ),
        },
      ];
    }, []);
  }
);
