import { createStore, applyMiddleware, compose } from 'redux';
import { apiMiddleware } from 'redux-api-middleware';
import logOutMiddleware from 'redux/middleware/logOutMiddleware';
import { routerMiddleware } from 'react-router-redux';
import { browserHistory } from 'react-router';
import flashMiddleware from 'redux/middleware/flashMiddleware';
import loadingMiddleware from 'redux/middleware/loadingMiddleware';
import thunk from 'redux-thunk';
import rootReducer from 'redux/modules/index';
import { isDev } from 'util/env';

const showDevTools = isDev() && !!window.devToolsExtension;

export default function configureStore(initialState = {}) {
  return createStore(
    rootReducer,
    initialState,
    compose(
      applyMiddleware(
        apiMiddleware,
        loadingMiddleware,
        logOutMiddleware,
        routerMiddleware(browserHistory),
        thunk,
        flashMiddleware
      ),
      showDevTools ? window.devToolsExtension() : (arg) => arg
    )
  );
}
