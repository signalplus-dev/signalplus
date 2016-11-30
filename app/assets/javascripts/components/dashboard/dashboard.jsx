import React from 'react';
import { provideHooks } from 'redial';
import { getBrandData } from 'redux/modules/models/brand.js';
import { getListenSignalsData } from 'redux/modules/models/listenSignals.js';
import { getSubscriptionPlansData } from 'redux/modules/models/subscriptionPlans.js';
import { getInvoicesData } from 'redux/modules/models/invoices.js';
import { actions } from 'redux/modules/app/index.js';

// Components
import SubscriptionSummary from 'components/dashboard/subscriptionSummary.jsx';
import BrandProfileBlock from 'components/dashboard/brandProfileBlock.jsx';
import Navigation from 'components/dashboard/navigation.jsx';
import ModalRoot from 'components/modals/index.jsx';

// Hooks to dispatch before rendering the dashboard
const hooks = {
  fetch: ({ dispatch }) => {
    Promise.all([
      dispatch(getBrandData()),
      dispatch(getListenSignalsData()),
      dispatch(getSubscriptionPlansData()),
      dispatch(getInvoicesData()),
    ]).then(() => dispatch(actions.subscribeToChannelsAction()));
  },
}

function Dashboard({ children, ...props }) {
  return (
    <div className="main">
      <div className="container-fluid">
        <div className="row">
          <ModalRoot />
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

export default provideHooks(hooks)(Dashboard);
