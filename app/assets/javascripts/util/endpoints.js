const endpoints = {
  TOKEN:                    '/api/v1/token',
  REFRESH_TOKEN:            '/users/refresh_token',
  TOKEN_SIGN_OUT:           '/api/v1/auth/sign_out',
  REGULAR_SIGN_OUT:         '/users/sign_out',
  VALIDATE_TOKEN:           '/api/v1/auth/validate_token',
  SUBSCRIPTION:             '/api/v1/subscriptions/:id',
  SUBSCRIPTIONS:            '/api/v1/subscriptions',
  SUBSCRIPTION_PLANS:       '/api/v1/subscription_plans',
  BRAND:                    '/api/v1/brands/me',
  BRAND_ACCOUNT_INFO:       '/api/v1/brands/account_info',
  BRAND_ACCOUNT_PLANS:      '/api/v1/brands/account_plans',
  LISTEN_SIGNALS_INDEX:     '/api/v1/listen_signals',
  LISTEN_SIGNAL_TEMPLATES:  '/api/v1/listen_signals/templates',
  LISTEN_SIGNAL:            '/api/v1/listen_signals/:id',
  PROMOTIONAL_SIGNAL_INDEX: '/api/v1/promotional_tweets/',
};

export function updateSubscriptionEndpoint(subscriptionId) {
  return endpoints.SUBSCRIPTION.replace(/:id/g, subscriptionId);
}

export function listenSignalEndpoint(listenSignalId) {
 return endpoints.LISTEN_SIGNAL.replace(/:id/g, listenSignalId);
}

export default endpoints;
