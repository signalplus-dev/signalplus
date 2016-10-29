import React, { Component } from 'react';
import { connect } from 'react-redux';
import Modal from 'react-modal';
import moment from 'moment';

export default class Invoice extends Component {
  constructor(props) {
    super(props);
    this.openModal = this.openModal.bind(this);
    this.afterOpenModal = this.afterOpenModal.bind(this);
    this.closeModal = this.closeModal.bind(this);

    this.state = { modalIsOpen: false };
  }

  componentWillMount() {
    Modal.setAppElement('body');
  }

  openModal() {
    this.setState({ modalIsOpen: true });
  }

  afterOpenModal() {
    this.refs.subtitle.style.color = '#f00';
  }

  closeModal() {
    this.setState({ modalIsOpen: false });
  }

  render() {
    const invoiceMonth = moment(this.props.invoice.created_at, moment.ISO_8601).format('MMMM YYYY');

    return (
      <div>
        <button onClick= {this.openModal} className='invoice'>
          {invoiceMonth}
        </button>

        <Modal
          isOpen={this.state.modalIsOpen}
          onAfterOpen={this.afterOpenModal}
          onRequestClose={this.closeModal}
          contentLabel='invoice-modal'
          overlayClassName='invoice-modal'
          className='invoice-modal-content'
        >
          <h2 ref="subtitle">Hello</h2>
          <button onClick={this.closeModal}>close</button>
          <div>I am a modal</div>
        </Modal>
      </div>

    )
  }
}
