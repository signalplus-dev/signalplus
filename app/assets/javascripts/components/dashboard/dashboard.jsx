import React from 'react';
import { provideHooks } from 'redial';
import { getBrandData } from '../../redux/modules/models/brand.js';
import { getListenSignalsData } from '../../redux/modules/models/listenSignals.js';

// Components
import SubscriptionSummary from '../subscriptionSummary.jsx';
import BrandProfileBlock from '../brandProfileBlock.jsx';
import Navigation from './navigation/navigation.jsx';

const hooks = {
  fetch: ({ dispatch }) => {
    dispatch(getBrandData());
    dispatch(getListenSignalsData());
  },
}

function Dashboard({ children, ...props }) {
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

export default provideHooks(hooks)(Dashboard);
