import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import _ from 'lodash';
import moment from 'moment';
import commaNumber from 'comma-number';
import { isTopSubscriptionSelector } from 'selectors/selectors.js'
import Loader from 'components/loader.jsx';

function renderUpgradeLink() {
  return (
    <div>
      <Link to="/subscription_plans" className="grayLink">
        Updgrade
      </Link>
    </div>
  );
}

function renderContent(subscription, isTopSubscription) {
  if (!subscription.loaded) return <Loader />;

  // Should never be the case, should have the free trial or the
  // expired free trial.
  if (_.isEmpty(subscription.data)) {
    return (
      <div>
        <div>No Subscription</div>
        <p><Link to="/subscription_plans" className="grayLink">Select One</Link></p>
      </div>
    );
  }

  return (
    <div>
      <div className="subscriptionName">{`${_.upperFirst(subscription.data.name)} Plan`}</div>
      <div>
        <div className="numMessages">
          <span className="sentMessages">
            {`${commaNumber(subscription.data.monthly_response_count)}/`}
          </span>
          <span className="maxMessages">
            {commaNumber(subscription.data.number_of_messages)}
          </span>
        </div>
        <span className="month">{moment().format('MMM YYYY')}<br />Responses</span>
      </div>
      {isTopSubscription ? undefined : renderUpgradeLink()}
    </div>
  );
}

function SubscriptionSummary({ subscription, isTopSubscription }) {
  return (
    <div className="brand-pricing-plan">
      {renderContent(subscription, isTopSubscription)}
    </div>
  );
}

// Load a selector in a way that allows memoization and caching across components
// https://github.com/reactjs/reselect#sharing-selectors-with-props-across-multiple-components
const makeSelector = () => isTopSubscriptionSelector;

export default connect(state => {
  const selector = makeSelector();

  return {
    subscription: state.models.subscription,
    isTopSubscription: selector(state),
  };
})(SubscriptionSummary);
