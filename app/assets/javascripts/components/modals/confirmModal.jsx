import React, { Component } from 'react';
import { connect } from 'react-redux';
import { actions as appActions } from 'redux/modules/app/index.js';
import Modal from 'react-modal';
import SignalIcon from 'components/links/signal_icon.jsx';


class ConfirmModal extends Component {
  constructor(props) {
    super(props);

    console.log('getting called here')
    this.closeModal = this.closeModal.bind(this);

    this.state = { isOpen: props.display}
  }

  componentWillMount() {
    Modal.setAppElement('body');
  }

  closeModal() {
    this.props.dispatch(appActions.hideModal());
  }

  render() {
    const { display, header, body } = this.props;

    return (
      <Modal
        isOpen={display}
        onRequestClose={this.closeModal}
        className='confirm-dialog-modal'
      >
        <div className='row confirm-modal-content'>
          <div className='col-xs-4 col-xs-offset-4'>
            <div className='modal-logo'>
              <SignalIcon type='welcome'/>
            </div>
            <div className='modal-text'>{header}</div>
            <div className='modal-subtext'>{body}</div>

            <span className='confirm-actions'>
              <button onClick={this.props.onConfirm} className='confirm-btn-yes'>Yes</button>
              <button onClick={this.closeModal} className='confirm-btn-no'>No</button>
            </span>
          </div>
        </div>
      </Modal>
    );
  }
}
export default connect()(ConfirmModal)

