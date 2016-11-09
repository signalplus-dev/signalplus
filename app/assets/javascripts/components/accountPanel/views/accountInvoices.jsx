import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';

// Component
import Invoice from 'components/accountPanel/views/invoice.jsx';


class AccountInvoices extends Component {
  renderInvoices(tz, invoices) {
    if (_.isEmpty(invoices)) {
      return <div className='invoice-absent'>There is no invoice at the moment</div>
    }

    return _.map(invoices, (invoice) => {
      return <Invoice key={invoice.id} tz={tz} invoice={invoice}/>
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
