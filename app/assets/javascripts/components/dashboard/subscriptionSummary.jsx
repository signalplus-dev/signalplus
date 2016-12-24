import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import _ from 'lodash';
import moment from 'moment';
import commaNumber from 'comma-number';
import { isTopSubscriptionSelector } from 'selectors/selectors.js'
import Loader from 'components/loader';

class SubscriptionSummary extends Component {
  renderTrialOrCanceledCopy() {
    const { subscription: { data: subscription } } = this.props;
    const { will_be_deactivated_at, trial, trial_end } = subscription;

    if (this.willBeDeactivated()) {
      const deactivatedDate = moment(will_be_deactivated_at);
      return (
        <div className="summaryHelperText">
          {`Your plan will be deactivated on ${deactivatedDate.format('MMM D')}`}
        </div>
      );
    } else if (trial) {
      return (
        <div className="summaryHelperText">
          {`Your trial will either end on ${moment(trial_end).format('MMM D')}`}
          <br />
          {`or after surpassing ${process.env.MAX_NUMBER_OF_MESSAGES_FOR_TRIAL} trial responses.`}
        </div>
      );
    }
  }

  renderContent() {
    const { subscription } = this.props;

    if (!subscription.loaded) return <Loader textOnly={true}/>;

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
        <div className="subscriptionName">
          {`${_.upperFirst(subscription.data.name)} Plan`}
          {this.renderTrialOrCanceledCopy()}
        </div>
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
        {this.renderUpgradeLink()}
      </div>
    );
  }

  willBeDeactivated() {
    const { subscription: { data: subscription } } = this.props;

    return (
      !!subscription.will_be_deactivated_at &&
      moment().isBefore(subscription.will_be_deactivated_at)
    );
  }

  isInactive() {
    const { subscription: { data: subscription } } = this.props;

    return (
      !!subscription.will_be_deactivated_at &&
      moment().isAfter(subscription.will_be_deactivated_at)
    );
  }

  renderUpgradeLink() {
    const { isTopSubscription } = this.props;
    let linkText;
    let link;

    if (this.willBeDeactivated()) {
      linkText = 'Reactivate';
      link = '/dashboard/account/current_plan';
    } else {
      link = '/subscription_plans';

      if (this.isInactive()) {
        linkText = 'Select Plan';
      } else if (isTopSubscription) {
        linkText = 'Change Plan';
        link = '/subscription_plans';
      } else {
        linkText = 'Upgrade';
        link = '/subscription_plans';
      }
    }

    return (
      <div>
        <Link to={link} className="grayLink">{linkText}</Link>
      </div>
    );
  }

  render() {
    const { subscription, isTopSubscription } = this.props;

    return (
      <div className="brand-pricing-plan">
        {this.renderContent()}
      </div>
    );
  }
}

// Load a selector in a way that allows memoization and caching across components
// https://github.com/reactjs/reselect#sharing-selectors-with-props-across-multiple-components
const makeSelector = () => isTopSubscriptionSelector;

export default connect(state => {
  const selector = makeSelector();

  return {
    subscription: state.models.subscription,
    brandId: state.models.brand.data.id,
    isTopSubscription: selector(state),
  };
})(SubscriptionSummary);
