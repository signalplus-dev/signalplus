import { createStore, applyMiddleware, compose } from 'redux';
import { apiMiddleware } from 'redux-api-middleware';
import logOutMiddleware from 'redux/middleware/logOutMiddleware.js';
import { routerMiddleware } from 'react-router-redux';
import { browserHistory } from 'react-router';
import flashMiddleware from 'redux/middleware/flashMiddleware.js';
import thunk from 'redux-thunk';
import rootReducer from 'redux/modules/index.js';
import { isDev } from 'util/env.js';

const showDevTools = isDev() && !!window.devToolsExtension;

export default function configureStore(initialState = {}) {
  return createStore(
    rootReducer,
    initialState,
    compose(
      applyMiddleware(
        apiMiddleware,
        logOutMiddleware,
        routerMiddleware(browserHistory),
        thunk,
        flashMiddleware
      ),
      showDevTools ? window.devToolsExtension() : (arg) => arg
    )
  );
}
