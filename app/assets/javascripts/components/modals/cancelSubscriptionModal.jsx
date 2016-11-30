import React, { Component } from 'react';
import { connect } from 'react-redux';
import { cancelSubscription } from 'redux/modules/models/subscription.js';

import ConfirmModal from 'components/modals/confirmModal.jsx';


class CancelSubscriptionModal extends Component {
  handleConfirm() {
    const { dispatch, subscriptionId } = this.props;

    dispatch(cancelSubscription(subscriptionId));
  }

  render() {
    const header = 'Are you sure you want to cancel your SignalPlus plan?';
    const body = 'Once your plan is successfully canceled you will receive a confirmation email.';

    return (
      <ConfirmModal
        display={this.props.display}
        onConfirm={this.handleConfirm}
        header={header}
        body={body}
      />
    );
  }
}

export default connect()(CancelSubscriptionModal);
