import { createStore, applyMiddleware, compose } from 'redux';
import { apiMiddleware } from 'redux-api-middleware';
import thunk from 'redux-thunk';
import rootReducer from 'redux/modules/index.js';

export default function configureStore(initialState = {}) {
  return createStore(
    rootReducer,
    initialState,
    compose(
      applyMiddleware(
        apiMiddleware,
        thunk
      ),
      window.devToolsExtension() // TODO - Make this not available in prod environment
    )
  );
}
