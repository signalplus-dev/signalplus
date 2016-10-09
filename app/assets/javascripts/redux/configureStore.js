import { createStore, applyMiddleware, compose } from 'redux';
import { apiMiddleware } from 'redux-api-middleware';
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
        thunk
      ),
      showDevTools ? window.devToolsExtension() : (arg) => arg
    )
  );
}
