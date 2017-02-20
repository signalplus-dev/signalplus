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
import configureStore from 'redux/configureStore';

// Components
import Dashboard from 'components/dashboard/dashboard';
import AccountPanel from 'components/accountPanel/accountPanel';
import AccountInfo from 'components/accountPanel/views/accountInfo';
import AccountSubscriptionPlan from 'components/accountPanel/views/accountSubscriptionPlan';
import SignalsPanel from 'components/signalsPanel/signalsPanel';
import TemplatesPanel from 'components/templatesPanel';
import ContentPanel from 'components/contentPanel/contentPanel';
import Edit from 'components/contentPanel/views/edit';
import Promote from 'components/contentPanel/views/promote';
import Preview from 'components/contentPanel/views/preview';
import SubscriptionPlansPage from 'components/subscriptionPlansPage';
import FinishSetup from 'components/finishSetup';
import Loader from 'components/loader';
import FullPageLoader from 'components/fullPageLoader';
import Header from 'components/header';
import FlashMessage from 'components/flashMessage';
import ModalRoot from 'components/modals/index';
import { getBrandData } from 'redux/modules/models/brand';
import { isRequestActionUnauthorized } from 'util/authentication';
import { logOut } from 'redux/modules/app/authentication';

// Import blocking App actions
import { actions as appActions } from 'redux/modules/app/index';

const store = configureStore();

function App({ children }) {
  return (
    <div>
      <Header />
      <FlashMessage />
      <ModalRoot />
      {children}
      <FullPageLoader />
    </div>
  );
}

const getBrand = (dispatch) => (nextState, replace, callback) => {
  return (
    dispatch(getBrandData())
      .then(() => callback())
      .catch(err => callback(err))
  );
}

const dashboardRedirects = (getState) => (nextState, replace, callback) => {
  const state = getState();
  const subscription = state.models.subscription.data;
  const brand = state.models.brand.data;

  if (!subscription.id) {
    return replace('/subscription_plans');
  } else if (!brand.accepted_terms_of_use) {
    return replace('/finish_setup');
  }

  callback();
};

const finishSetupRedirect = (getState) => (nextState, replace, callback) => {
  const state = getState();
  const brand = state.models.brand.data;

  if (brand.accepted_terms_of_use) {
    replace('/dashboard');
  }

  callback();
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
      <Route path="/" component={App} onEnter={getBrand(dispatch)}>
        <IndexRedirect to="dashboard" />
        <Route path="dashboard" component={Dashboard} onEnter={dashboardRedirects(getState)}>
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
        <Route path="subscription_plans" component={SubscriptionPlansPage} />
        <Route
          path="finish_setup"
          component={FinishSetup}
          onEnter={finishSetupRedirect(getState)}
        />
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
