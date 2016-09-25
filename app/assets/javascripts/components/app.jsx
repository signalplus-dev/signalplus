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

// Import blocking App actions
import { actions as appActions } from '../redux/modules/app.js';

const store = configureStore();

function App({ children }) {
  return <div className="row">{children}</div>;
}

function UnconnectedAppRouter({ authenticated }) {
  if (!authenticated) {
    return <App><Loader /></App>;
  }

  return (
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
            <Route path=":id" component={ContentPanel} />
            <Route path="new" component={ContentPanel}>
              <IndexRedirect to="offer" />
              <Route path=":type">

              </Route>
            </Route>
          </Route>
          <Route path="templates" component={TemplatesPane}/>

          {/* Keep at bottom; this is a catch all for any routes that don't exist */}
          <Redirect from="*" to="signals"/>
        </Route>
        <Route path="subscription_plans" component={SubscriptionPlans} />
      </Route>
    </Router>
  );
}

const AppRouter = connect(state => ({
  authenticated: state.app.authenticated,
}))(UnconnectedAppRouter);


export default class Root extends Component {
  componentWillMount() {
    const { dispatch } = store;

    if (!restInterface.hasToken() || restInterface.isTAExpired()) {
      restInterface.refreshToken().then(response => {
        dispatch(appActions.authenticated());
      });
    } else {
      dispatch(appActions.authenticated());
    }
  }

  render() {
    return <Provider {...{ store }}><AppRouter /></Provider>;
  }
}
