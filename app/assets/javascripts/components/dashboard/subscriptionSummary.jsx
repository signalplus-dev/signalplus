import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import _ from 'lodash';
import moment from 'moment';
import Loader from 'components/loader.jsx';

class SubscriptionSummary extends Component {
  renderContent() {
    const { subscription } = this.props;

    if (!subscription.loaded) return <Loader />;

    // Should never be the case, should have the free trial or the
    // expired free trial.
    if (_.isEmpty(subscription.data)) {
      return (
        <div>
          <div>No Subscription</div>
          <p><Link to="/subscription_plans">Select One</Link></p>
        </div>
      );
    }

    return (
      <div>You have a subscription!</div>
    );
  }

  render() {
    return (
      <div className="brand-pricing-plan">
        {this.renderContent()}
      </div>
    );
  }
}

export default connect(state => ({
  subscription: state.models.subscription,
}))(SubscriptionSummary);
