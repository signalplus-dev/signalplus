import React, { Component } from 'react';
import moment from 'moment';
import { connect } from 'react-redux';
import _ from 'lodash';


// TODO: INVOICE COMPONENT WIP
export function Invoice({ tz, invoice }) {
  const invoiceMonth = moment(invoice.created_at, moment.ISO_8601).format('MMMM YYYY');

  return (
    <div className='invoice'>
      <a>
        {invoiceMonth}
      </a>
    </div>
  );
}

class AccountInvoice extends Component {
  renderInvoices(tz, invoices) {
    return _.map(invoices, (invoice) => {
      if (invoice) {
        return <Invoice key={invoice.id} tz={tz} invoice={invoice}/>
      }

      return <div className='invoice-absent'>'You have no invoices yet'</div>
    });
  }

  render() {
    const { tz, invoices } = this.props;

    return (
      <div className='invoice-panel'>
        {this.renderInvoices(tz, invoices)}
      </div>
    );
  };
}

export default connect((state) => ({
  tz: state.models.brand.data.tz,
  invoices: state.models.invoices.data,
}))(AccountInvoice);
