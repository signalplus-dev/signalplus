import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';

// Components
import Invoice from 'components/accountPanel/views/invoice.jsx'

class AccountInvoices extends Component {
  renderInvoices(brand, invoices) {
    if (_.isEmpty(invoices)) {
      return <div className='invoice-absent'>There is no invoice at the moment</div>
    }

    return _.map(invoices, (invoice) => {
      return <Invoice key={invoice.id} brand={brand} invoice={invoice}/>
    });
  }

  render() {
    const { brand, invoices } = this.props;

    return (
      <div className='invoice-panel'>
        {this.renderInvoices(brand, invoices)}
      </div>
    );
  };
}

export default connect((state) => ({
  brand: state.models.brand.data,
  invoices: state.models.invoices.data,
}))(AccountInvoices);
