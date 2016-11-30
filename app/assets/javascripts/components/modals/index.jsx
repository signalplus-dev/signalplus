import React, { Component } from 'react';
import { connect } from 'react-redux';

// Components
import DeleteSignalModal from 'components/modals/deleteSignalModal.jsx';
import CancelSubscriptionModal from 'components/modals/cancelSubscriptionModal.jsx';

const MODAL_COMPONENTS = {
  'DELETE_SIGNAL': DeleteSignalModal,
  'CANCEL_SUBSCRIPTION': CancelSubscriptionModal,
}

const ModalRoot = ({ modal: { modalType, modalProps, display }}) => {
  if (!modalType) {
    return null;
  }

  const SpecificModal = MODAL_COMPONENTS[modalType];
  return <SpecificModal display={display} { ...modalProps } />
}

export default connect((state) => ({
  modal: state.app.modal,
}))(ModalRoot)
