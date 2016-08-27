require('babel-polyfill');

window.Navigation = global.Navigation = require('./components/dashboard/navigation/navigation.jsx').default;
window.LogOutLink = global.LogOutLink = require('./components/logOutLink.jsx').default;
