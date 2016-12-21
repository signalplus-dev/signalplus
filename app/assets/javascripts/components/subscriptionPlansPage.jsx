import React, { Component } from 'react'
import { provideHooks } from 'redial';

import { getSubscriptionPlansData } from 'redux/modules/models/subscriptionPlans'
import { getBrandData } from 'redux/modules/models/brand'

import SubscriptionPlans from 'components/subscriptionPlans/subscriptionPlans';

function SubscriptionPlansPage() {
  return (
    <div className="main">
      <div className="container-fluid">
        <div className="row">
          <div className="col-xs-12 page">
            <div className="pageHeader">
              <h1>Select a Plan</h1>
              <p>
                Select the amount of responses for your account. You can change your plan at anytime.
                <br />
                <strong>
                  {
                    `SignalPlus is free for ${process.env.NUMBER_OF_DAYS_OF_TRIAL} days ` +
                    `or ${process.env.MAX_NUMBER_OF_MESSAGES_FOR_TRIAL} responses (cancel anytime).`
                  }
                </strong>
              </p>
            </div>
            <SubscriptionPlans />
          </div>
        </div>
      </div>
    </div>
  );
}

const hooks = {
  fetch: ({ dispatch }) => {
    dispatch(getSubscriptionPlansData());
    dispatch(getBrandData());
  },
};

export default provideHooks(hooks)(SubscriptionPlansPage)
