import React, { Component } from 'react';
import { Provider, connect } from 'react-redux';
import { provideHooks } from 'redial';
import {
  Router,
  IndexRoute,
  IndexRedirect,
  Route,
  Redirect,
  browserHistory,
} from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux';
import { RedialContext } from 'react-router-redial';
import configureStore from '../redux/configureStore.js';
import restInterface from '../util/restInterface.js';

// Components
import Dashboard from './dashboard/dashboard.jsx';
import SignalsPane from './dashboard/navigation/panels/signals/signals_pane.jsx';
import TemplatesPane from './dashboard/navigation/panels/templates/templates_pane.jsx';
import ContentPanel from './dashboard/navigation/content_panel/content_panel.jsx';
import SubscriptionPlans from './subscriptionPlans/subscriptionPlans.jsx';
import Loader from './loader.jsx';

// Import blocking App hooks
import { actions as appActions } from '../redux/modules/app.js';

function App({ authenticated, children, data }) {
  if (authenticated) {
    return (
      <div className="row">
        {React.cloneElement(children, { data })}
      </div>
    );
  }

  return <Loader />;
}

const ConnectedApp = connect(state => ({
  authenticated: state.app.authenticated,
}))(App);

const hooks = {
  fetch: ({ dispatch }) => {
    if (!restInterface.hasToken() || restInterface.isTAExpired()) {
      restInterface.refreshToken().then(response => {
        dispatch(appActions.authenticated());
      });
    } else {
      dispatch(appActions.authenticated());
    }
  },
};

export default function Root({ data }) {
  const store = configureStore();
  function ConnectedAppWithData(props) {
    return <ConnectedApp {...{ ...props, data }} />;
  }

  const App = provideHooks(hooks)(ConnectedAppWithData);

  return (
    <Provider {...{ store }}>
      <Router
        history={syncHistoryWithStore(browserHistory, store)}
        render={props => (
          <RedialContext
            {...props}
            locals={{ dispatch: store.dispatch }}
            blocking={['fetch']}
            defer={['defer', 'done']}
            parallel={true}
            initialLoading={() => <div>Loading…</div>}
          />
        )}
      >
        <Route path="/" component={App}>
          <IndexRedirect to="dashboard" />
          <Route path="dashboard" component={Dashboard}>
            <IndexRedirect to="signals" />
            <Route path="signals">
              <IndexRedirect to="active" />
              <Route path="active" component={SignalsPane} />
            </Route>
            <Route path="templates" component={TemplatesPane}/>
            <Route path="new" component={ContentPanel}>
              <IndexRedirect to="offer" />
              <Route path=":type">

              </Route>
            </Route>
            <Route path="edit" component={ContentPanel} />

            {/* Keep at bottom; this is a catch all for any routes that don't exist */}
            <Redirect from="*" to="signals"/>
          </Route>
          <Route path="subscription_plans" component={SubscriptionPlans} />
        </Route>
      </Router>
    </Provider>
  );
}
