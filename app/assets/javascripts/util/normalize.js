import _ from 'lodash';

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
