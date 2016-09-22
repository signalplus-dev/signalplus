import React, { Component } from 'react';
import { Provider, connect } from 'react-redux';
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
import { actions as appActions } from '../redux/modules/app.js';
import restInterface from '../util/restInterface.js';

// Components
import SubscriptionSummary from './subscriptionSummary.jsx';
import BrandProfileBlock from './brandProfileBlock.jsx';
import Navigation from './dashboard/navigation/navigation.jsx';
import SignalsPane from './dashboard/navigation/panels/signals/signals_pane.jsx';
import TemplatesPane from './dashboard/navigation/panels/templates/templates_pane.jsx';
import ContentPanel from './dashboard/navigation/content_panel/content_panel.jsx';
import Loader from './loader.jsx';


function Dashboard({ children, ...props}) {
  return (
    <div className="dash">
      <div className="col-md-12 dash-header">
        <BrandProfileBlock />
        <SubscriptionSummary />
      </div>
      <div className="col-md-12 dash">
        <Navigation {...props}>{children}</Navigation>
      </div>
    </div>
  );
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
    const { authenticated, children, data } = this.props;

    if (authenticated) {
      return <div className="row">
        {React.cloneElement(children, { data })}
      </div>;
    }

    return <Loader />;
  }
}


const ConnectedApp = connect(state => ({ authenticated: state.app.authenticated }))(App);


export default function Root({ data }) {
  const store = configureStore();
  function ConnectedAppWithData(props) {
    return <ConnectedApp {...{ ...props, data }} />;
  }

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
        <Route path="/" component={ConnectedAppWithData}>
          <IndexRedirect to="dashboard" />
          <Route path="dashboard" component={Dashboard}>
            <IndexRedirect to="signals" />
            <Route path="signals">
              <IndexRedirect to="active" />
              <Route path="active" component={SignalsPane} />
              <Route path=":id" component={ContentPanel}>
                
              </Route>
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
        </Route>
      </Router>
    </Provider>
  );
}
