import React, { Component } from 'react';
import { Provider, connect } from 'react-redux';
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

  return (
    <Provider {...{ store }}>
      <ConnectedApp {...{ data }} />
    </Provider>
  );
}
