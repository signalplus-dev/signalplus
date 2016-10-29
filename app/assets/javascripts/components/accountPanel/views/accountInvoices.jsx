import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';

// Component
import Invoice from 'components/accountPanel/views/invoice.jsx';


class AccountInvoices extends Component {
  renderInvoices(tz, invoices) {
    return _.map(invoices, (invoice) => {
      if (invoice) {
        return <Invoice key={invoice.id} tz={tz} invoice={invoice}/>
      }

      return <div className='invoice-absent'>There is no invoice at the moment</div>
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
}))(AccountInvoices);
