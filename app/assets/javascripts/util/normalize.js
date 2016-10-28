import _ from 'lodash';
import { normalize, Schema, arrayOf } from 'normalizr';

/**
  * Extracts brand info from the brand payload response without the subscription info
  *
  * @param {Object} brandPayload - JSON brand payload response from the server
  * @return {Object}
*/
export function normalizeBrand(brandPayload) {
  return {
    data: _.omit(_.get(brandPayload, 'brand', {}), 'subscription'),
    loaded: true,
    loading: false,
  };
}

/**
  * Extracts the subscription from the brand payload response
  *
  * @param {Object} brandPayload - JSON brand payload response from the server
  * @return {Object}
*/
export function normalizeSubscription(brandPayload) {
  return {
    data: _.get(brandPayload, 'brand.subscription', {}) || {},
    loaded: true,
    loading: false,
  };
}


// Schemas for the listen signals, responses, and promotional tweets
const listenSignals = new Schema('listenSignals');
const listenSignal = new Schema('listenSignal');
const responses = new Schema('responses');
const promotionalTweets = new Schema('promotionalTweets');

listenSignals.define({
  responses: arrayOf(responses),
  promotional_tweets: arrayOf(promotionalTweets),
});

listenSignal.define({
  responses: arrayOf(responses),
  promotional_tweets: arrayOf(promotionalTweets),
});


/**
  * Normalized version of the listenSignalsPayload from the API.
  *
  * @param {Object} listenSignalsPayload - JSON payload response from the server for the brand's
  *                                        listen signals.
  * @return {Object}
*/
export function normalizeListenSignalsResponse(listenSignalsPayload) {
  return normalize(listenSignalsPayload, { listen_signals: arrayOf(listenSignals) });
}

export function normalizeListenSignalResponse(listenSignalPayload) {
  return normalize(listenSignalPayload, { listen_signal: listenSignal });
}

// Schemas for the subsciption plans
const subscriptionPlans = new Schema('subscriptionPlans');
export function normalizeSubscriptionPlansResponse(subscriptionPlansPayload) {
  return normalize(subscriptionPlansPayload, { subscription_plans: arrayOf(subscriptionPlans) });
}

// Schemas for the invoices
const invoices = new Schema('invoices');
export function normalizeInvoicesResponse(invoicesPayload) {
  return normalize(invoicesPayload, { invoices: arrayOf(invoices) });
}
