import React, { Component } from 'react';
import { Provider, connect } from 'react-redux';
import { Router, Route, browserHistory } from 'react-router'
import { RedialContext } from 'react-router-redial';
import configureStore from '../redux/configureStore.js';
import { actions as appActions } from '../redux/modules/app.js';
import restInterface from '../util/restInterface.js';

// Components
import SubscriptionSummary from './subscriptionSummary.jsx';
import BrandProfileBlock from './brandProfileBlock.jsx';
import Navigation from './dashboard/navigation/navigation.jsx';
import Loader from './loader.jsx';


function renderApp(data, authenticated) {
  if (authenticated) {
    return (
      <div className="dash">
        <div className="col-md-12 dash-header">
          <BrandProfileBlock />
          <SubscriptionSummary />
        </div>
        <div className="col-md-12 dash">
          <Navigation {...{ data }} />
        </div>
      </div>
    );
  }

  return <Loader />;
}

// function Dashboard({ data }) {

// }

class App extends Component {
  componentWillMount() {
    const { dispatch } = this.props;

    if (!restInterface.hasToken() || restInterface.isTAExpired()) {
      restInterface.refreshToken().then(response => {
        dispatch(appActions.authenticated());
      });
    } else {
      dispatch(appActions.authenticated());
    }
  }

  render() {
    const { data, authenticated } = this.props;
    return <div className="row">{renderApp(data, authenticated)}</div>;
  }
}


const ConnectedApp = connect(state => ({ authenticated: state.app.authenticated }))(App);


export default function Root({ data }) {
  const store = configureStore();
  function ConnectedAppWithData() {
    return <ConnectedApp {...{ data }} />;
  }

  return (
    <Provider {...{ store }}>
      <Router
        history={browserHistory}
        render={props => (
          <RedialContext
            {...props}
            blocking={ ['fetch'] }
            defer={['defer', 'done' ]}
            parallel={true}
            initialLoading={() => <div>Loading…</div>}
          />
        )}
      >
        <Route path="/dashboard/index" component={ConnectedAppWithData}></Route>
      </Router>
    </Provider>
  );
}
