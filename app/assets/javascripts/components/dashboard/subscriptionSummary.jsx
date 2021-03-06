import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import _ from 'lodash';
import moment from 'moment';
import commaNumber from 'comma-number';
import cn from 'classnames';
import { isTopSubscriptionSelector } from 'selectors/selectors.js'
import Loader from 'components/loader';

class SubscriptionSummary extends Component {
  renderTrialOrCanceledCopy() {
    const { subscription: { data: subscription } } = this.props;
    const { will_be_deactivated_at, trialing, trial_end } = subscription;

    if (this.willBeDeactivated()) {
      const deactivatedDate = moment(will_be_deactivated_at);
      return (
        <div className="summaryHelperText">
          {`Your plan will be deactivated on ${deactivatedDate.format('MMM D')}`}
        </div>
      );
    } else if (this.isInactive()) {
      return (
        <div className="summaryHelperText">
          Your account is inactive and SignalPlus<br />
          is not listening for any signals.
        </div>
      );
    } else if (trialing) {
      return (
        <div className="summaryHelperText">
          {`Your trial will either end on ${moment(trial_end).format('MMM D')}`}
          <br />
          {`or after surpassing ${process.env.MAX_NUMBER_OF_MESSAGES_FOR_TRIAL} trial responses.`}
        </div>
      );
    }

    return undefined;
  }

  renderBlockTitle() {
    const { subscription } = this.props;

    if (this.isInactive()) {
      return <span className="inactive">Inactive</span>;
    }

    return `${_.upperFirst(subscription.data.name)} Plan`
  }

  renderSubscriptionInformation() {
    if (!this.isInactive()) {
      const { subscription } = this.props;

      return (
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
      );
    }

    return undefined;
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

    const titleClasses = cn({
      subscriptionName: true,
      inactive: this.isInactive(),
    });

    return (
      <div>
        <div className={titleClasses}>
          {this.renderBlockTitle()}
          {this.renderTrialOrCanceledCopy()}
        </div>
        {this.renderSubscriptionInformation()}
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

    if (this.willBeDeactivated()) {
      linkText = 'Reactivate';
    } else if (this.isInactive()) {
      linkText = 'Select Plan';
    } else if (isTopSubscription) {
      linkText = 'Change Plan';
    } else {
      linkText = 'Upgrade';
    }

    return (
      <div>
        <Link to="/subscription_plans" className="grayLink">{linkText}</Link>
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
