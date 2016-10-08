export const ENVIRONMENTS = {
  PRODUCTION: 'production',
  DEVELOPMENT: 'development',
};

export const isProd = () => process.env.RAILS_ENV === ENVIRONMENTS.PRODUCTION;
export const isDev = () => process.env.RAILS_ENV === ENVIRONMENTS.DEVELOPMENT;
