import React, { Component } from 'react';
import { connect } from 'react-redux';
import { actions as appActions } from 'redux/modules/app/index';
import { deleteListenSignalData } from 'redux/modules/models/listenSignals';
import { browserHistory } from 'react-router';

// Components
import ConfirmModal from 'components/modals/confirmModal';

const ACTIVE_SIGNAL_PATH = '/dashboard/signals/active';

class CancelSubscriptionModal extends Component {
  constructor(props) {
    super(props);
    this.handleConfirm = this.handleConfirm.bind(this);
  }

  handleConfirm() {
    const { dispatch, signal, tabId } = this.props;

    dispatch(deleteListenSignalData(signal));
    dispatch(appActions.removeTab(tabId)).then(() => {
      browserHistory.push(ACTIVE_SIGNAL_PATH);
    });
  }

  render() {
    const header = 'Are you sure you want to delete this signal?';
    const body = ''
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
