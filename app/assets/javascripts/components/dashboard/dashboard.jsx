import React, { PureComponent } from 'react';
import { provideHooks } from 'redial';
import { getBrandData } from 'redux/modules/models/brand.js';
import { getListenSignalsData } from 'redux/modules/models/listenSignals.js';
import { getSubscriptionPlansData } from 'redux/modules/models/subscriptionPlans.js';
import { getInvoicesData } from 'redux/modules/models/invoices.js';
import { actions } from 'redux/modules/app/index.js';
import { browserHistory } from 'react-router';

// Components
import SubscriptionSummary from 'components/dashboard/subscriptionSummary.jsx';
import BrandProfileBlock from 'components/dashboard/brandProfileBlock.jsx';
import Navigation from 'components/dashboard/navigation.jsx';

// Hooks to dispatch before rendering the dashboard
const hooks = {
  fetch: ({ dispatch, getState, setProps }) => {
    Promise.all([
      dispatch(getBrandData()).then(() => {
        const subscription = getState().models.subscription.data;
        if (!subscription.id) {
          setProps({ redirect: '/subscription_plans' });
        }
      }),
      dispatch(getListenSignalsData()),
      dispatch(getSubscriptionPlansData()),
      dispatch(getInvoicesData()),
    ]).then(() => dispatch(actions.subscribeToChannelsAction()));
  },
}

class Dashboard extends PureComponent {
  componentWillMount() {
    const { redirect, abort } = this.props;

    if (redirect) {
      browserHistory.push(redirect);
      abort();
    }
  }

  render() {
    const { children, ...props } = this.props;

    return (
      <div className="main">
        <div className="container-fluid">
          <div className="row">
            <div className="col-xs-12 dash-header">
              <BrandProfileBlock />
              <SubscriptionSummary />
            </div>
          </div>
        </div>

        <Navigation {...props}>{children}</Navigation>
      </div>
    );
  }
}

export default provideHooks(hooks)(Dashboard);
