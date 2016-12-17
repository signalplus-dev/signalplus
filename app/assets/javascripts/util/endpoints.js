const endpoints = {
  TOKEN:                    '/api/v1/token',
  REFRESH_TOKEN:            '/users/refresh_token',
  TOKEN_SIGN_OUT:           '/api/v1/auth/sign_out',
  REGULAR_SIGN_OUT:         '/users/sign_out',
  VALIDATE_TOKEN:           '/api/v1/auth/validate_token',
  SUBSCRIPTION:             '/api/v1/subscriptions/:id',
  SUBSCRIPTIONS:            '/api/v1/subscriptions',
  SUBSCRIPTION_PLANS:       '/api/v1/subscription_plans',
  SUBSCRIPTION_CANCEL:      '/api/v1/subscriptions/:id/cancel',
  BRAND:                    '/api/v1/brands/me',
  USER:                     '/api/v1/users/me',
  USER_UPDATE:              '/api/v1/users/:id',
  LISTEN_SIGNALS_INDEX:     '/api/v1/listen_signals',
  LISTEN_SIGNAL_TEMPLATES:  '/api/v1/listen_signals/templates',
  LISTEN_SIGNAL:            '/api/v1/listen_signals/:id',
  PROMOTIONAL_SIGNAL_INDEX: '/api/v1/promotional_tweets',
  INVOICES:                 '/api/v1/invoices',
};

export function cancelSubscriptionEndpoint(subscriptionId) {
  return endpoints.SUBSCRIPTION_CANCEL.replace(/:id/g, subscriptionId);
}

export function updateSubscriptionEndpoint(subscriptionId) {
  return endpoints.SUBSCRIPTION.replace(/:id/g, subscriptionId);
}

export function listenSignalEndpoint(listenSignalId) {
 return endpoints.LISTEN_SIGNAL.replace(/:id/g, listenSignalId);
}

export function userUpdateEndpoint(userId) {
 return endpoints.USER_UPDATE.replace(/:id/g, userId);
}

export default endpoints;
