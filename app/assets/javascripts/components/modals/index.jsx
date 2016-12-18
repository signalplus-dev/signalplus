import React, { Component } from 'react';
import { connect } from 'react-redux';

import { MODAL_COMPONENTS } from 'components/modals/modalConstants';

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
