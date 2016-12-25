import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';

import { sortedInvoices } from 'selectors/selectors';

// Components
import Invoice from 'components/accountPanel/views/invoice.jsx'

class AccountInvoices extends Component {
  renderInvoices() {
    const { brand, invoices } = this.props;

    if (_.isEmpty(invoices)) {
      return <div className='invoice-absent'>You have no invoices at the moment.</div>
    }

    return _.map(invoices, (invoice) => {
      return <Invoice key={invoice.id} brand={brand} invoice={invoice} />
    });
  }

  render() {
    return (
      <div className='invoice-panel'>
        {this.renderInvoices()}
      </div>
    );
  };
}

const makeInvoicesSelector = () => sortedInvoices;
const makeMapStateToProps = () => {
  const selector = makeInvoicesSelector();

  return (state, ownProps) => ({
    brand: state.models.brand.data,
    invoices: selector(state),
  });
};

export default connect(makeMapStateToProps)(AccountInvoices);
