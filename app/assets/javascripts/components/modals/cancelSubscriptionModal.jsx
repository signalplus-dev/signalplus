import React, { Component } from 'react';
import { connect } from 'react-redux';
import { cancelSubscription } from 'redux/modules/models/subscription';

import ConfirmModal from 'components/modals/confirmModal';


class CancelSubscriptionModal extends Component {
  constructor(props) {
    super(props);
    this.handleConfirm = this.handleConfirm.bind(this);
  }

  handleConfirm() {
    const { dispatch, subscription } = this.props;
    dispatch(cancelSubscription(subscription));
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
