import React from 'react';
import { provideHooks } from 'redial';
import { getBrandData } from 'redux/modules/models/brand.js';
import { getListenSignalsData } from 'redux/modules/models/listenSignals.js';

// Components
import SubscriptionSummary from 'components/dashboard/subscriptionSummary.jsx';
import BrandProfileBlock from 'components/dashboard/brandProfileBlock.jsx';
import Navigation from 'components/dashboard/navigation.jsx';

const hooks = {
  fetch: ({ dispatch }) => {
    dispatch(getBrandData());
    dispatch(getListenSignalsData());
  },
}

function Dashboard({ children, ...props }) {
  return (
    <div className="dash row">
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

export default provideHooks(hooks)(Dashboard);
