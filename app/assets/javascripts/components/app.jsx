import React, { Component } from 'react';
import { Provider, connect } from 'react-redux';
import {
  Router,
  IndexRoute,
  IndexRedirect,
  Route,
  Redirect,
  browserHistory,
  applyRouterMiddleware,
} from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux';
import { useRedial } from 'react-router-redial';
import configureStore from 'redux/configureStore.js';

// Components
import Dashboard from 'components/dashboard/dashboard.jsx';
import AccountPanel from 'components/accountPanel/accountPanel.jsx';
import AccountInfo from 'components/accountPanel/views/accountInfo.jsx';
import AccountSubscriptionPlan from 'components/accountPanel/views/accountSubscriptionPlan.jsx';
import SignalsPanel from 'components/signalsPanel/signalsPanel.jsx';
import TemplatesPanel from 'components/templatesPanel.jsx';
import ContentPanel from 'components/contentPanel/contentPanel.jsx';
import Edit from 'components/contentPanel/views/edit.jsx';
import Promote from 'components/contentPanel/views/promote.jsx';
import Preview from 'components/contentPanel/views/preview.jsx';
import SubscriptionPlans from 'components/subscriptionPlans/subscriptionPlans.jsx';
import Loader from 'components/loader.jsx';
import Header from 'components/header.jsx';
import FlashMessage from 'components/flashMessage.jsx';
import ModalRoot from 'components/modals/index.jsx';

// Import blocking App actions
import { actions as appActions } from 'redux/modules/app/index.js';

const store = configureStore();

function App({ children }) {
  return (
    <div>
      <Header />
      <FlashMessage />
      <ModalRoot />
      {children}
    </div>
  );
}

function UnconnectedAppRouter({ authenticated }) {
  if (!authenticated) {
    return <App><Loader /></App>;
  }
  const { dispatch, getState } = store;

  return (
    <Router
      history={syncHistoryWithStore(browserHistory, store)}
      render={applyRouterMiddleware(
        useRedial({
          locals: { dispatch, getState },
          beforeTransition: ['fetch'],
          afterTransition: ['defer', 'done'],
          parallel: true,
          initialLoading: () => <div>Loading…</div>,
        })
      )}
    >
      <Route path="/" component={App}>
        <IndexRedirect to="dashboard" />
        <Route path="dashboard" component={Dashboard}>
          <Route path="account" component={AccountPanel}>
            <IndexRoute component={AccountInfo} />
            <Route path="current_plan" component={AccountSubscriptionPlan} />
          </Route>

          <IndexRedirect to="signals" />
          <Route path="signals">
            <IndexRedirect to="active" />

            <Route path="active" component={SignalsPanel} />
            <Route path=":id" component={ContentPanel}>
              <IndexRoute component={Edit} />
              <Route path="promote" component={Promote} />
              <Route path="preview" component={Preview} />
            </Route>
            <Route path="new" component={ContentPanel}>
              <IndexRedirect to="offer" />
              <Route path=":type">
                <IndexRoute component={Edit} />
                <Route path="promote" component={Promote} />
                <Route path="preview" component={Preview} />
              </Route>
              <Redirect from="*" to="offer"/>
            </Route>
          </Route>
          <Route path="templates" component={TemplatesPanel}/>

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
  componentDidMount() {
    store.dispatch(appActions.authenticate());
  }

  render() {
    return <Provider {...{ store }}><AppRouter /></Provider>;
  }
}
