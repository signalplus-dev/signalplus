require('babel-polyfill');

const App = require('./components/app.jsx').default;
const SubscriptionPlans = require('./components/subscriptionPlans/subscriptionPlans.jsx').SubscriptionPlans;

window.App = global.App = App;
window.SubscriptionPlans = global.SubscriptionPlans = SubscriptionPlans;
