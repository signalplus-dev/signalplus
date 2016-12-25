import React, { Component } from 'react';
import { connect } from 'react-redux';
import Modal from 'react-modal';
import moment from 'moment';

// Components
import SVGInline from 'react-svg-inline';
import svgClose from 'icons/close.svg';


export default class Invoice extends Component {
  constructor(props) {
    super(props);
    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.renderLineItems = this.renderLineItems.bind(this);
    this.convertToDollarString = this.convertToDollarString.bind(this);

    this.state = { modalIsOpen: false };
  }

  componentWillMount() {
    Modal.setAppElement('body');
  }

  openModal() {
    this.setState({ modalIsOpen: true });
  }

  closeModal() {
    this.setState({ modalIsOpen: false });
  }


  timestampToDate(timestamp, format) {
    return moment.unix(timestamp).format(format);
  }

  convertToDollarString(cents) {
    return `$ ${cents / 100}`;
  }

  renderLineItems(lineItems) {
    return lineItems.map((lineItem, index) => {
      return (
        <div key={index} className='row'>
          <div className='col-xs-4'>
            <p className='invoice-text'>{lineItem.plan_name}</p>
          </div>
          <div className='col-xs-5'>
            <p className='invoice-text'>
              {`${this.timestampToDate(lineItem.period.start, 'MMM D, YYYY')} -
                ${this.timestampToDate(lineItem.period.start, 'MMM D, YYYY')}`}
            </p>
          </div>
          <div className='col-xs-3'>
            <p className='invoice-text'>
              {this.convertToDollarString(lineItem.amount)}
            </p>
          </div>
        </div>
      )
    });
  }

  render() {
    const { brand, invoice } = this.props;
    const invoiceStart =  moment(invoice.period_start).format('MMM D');
    const invoiceEnd =  moment(invoice.period_end).format('MMM D');
    const invoiceDateStart = this.timestampToDate(invoice.data.period_start, 'MMM D, YYYY');
    const invoiceDateEnd = this.timestampToDate(invoice.data.period_end, 'MMM D, YYYY');

    return (
      <div>
        <button onClick= {this.openModal} className='invoice'>
          {`${invoiceStart} – ${invoiceEnd}`}
        </button>

        <Modal
          isOpen={this.state.modalIsOpen}
          onRequestClose={this.closeModal}
          contentLabel='invoice-modal'
          overlayClassName='invoice-modal'
          className='invoice-modal-content'
        >
          <button className='tab-close-btn' onClick={this.closeModal}>
            <SVGInline cleanup svg={svgClose} className="close-svg clearfix" />
          </button>

          <div className='invoice-header'>
            <img src={window.__IMAGE_ASSETS__.logoSignalplusInvoicePng} alt="SignalPlus +" height="40" />
            <span className='invoice-dates'>
              {invoiceDateStart} – {invoiceDateEnd}
            </span>
            <h2 className='invoice-heading'>{`Invoice #${invoice.stripe_invoice_id}`}</h2>
          </div>

          <div className='invoice-customer-info'>
            <p className='invoice-label'>Customer</p>
            <p className='invoice-text'>
              #{brand.name} <br/>
              {brand.twitter_admin_email}
            </p>
          </div>
          <div className='row'>
            <div className='col-xs-4'>
              <p className='invoice-label'>Description</p>
            </div>
            <div className='col-xs-5'>
              <p className='invoice-label'>Dates</p>
            </div>
            <div className='col-xs-3'>
              <p className='invoice-label'>Price</p>
            </div>
          </div>

          {this.renderLineItems(invoice.data.line_items)}

          <div className='row'>
            <div className='invoice-summary'>
              <div className='col-xs-4'>
                <p className='invoice-label'>Total</p>
                <p className='invoice-label'>Amount Due</p>
              </div>
              <div className='col-xs-5'></div>
              <div className='col-xs-3'>
                <p className='invoice-amount'>{this.convertToDollarString(invoice.data.total)}</p>
                <p className='invoice-due'>{this.convertToDollarString(invoice.data.amount_due)}</p>
              </div>
            </div>
          </div>
          <div className='invoice-footer'>
            <p>If you have any billing questions, please reach out to billing@signaliplus.com</p>
          </div>
        </Modal>
      </div>

    )
  }
}
