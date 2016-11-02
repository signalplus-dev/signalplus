import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';

// Component
import Loader from 'components/loader.jsx';
import InputBox from 'components/forms/inputBox.jsx';
import AccountInvoices from 'components/accountPanel/views/accountInvoices.jsx';


class AccountSubscriptionPlan extends Component {
  renderContent() {
    const { subscription, subscriptionPlans } = this.props;

    if (!subscription.loaded && !subscriptionPlans.loaded) return <Loader/>;

    const { 
      amount, 
      description, 
      number_of_messages, 
      currency_symbol,
    } = subscriptionPlans.data[subscription.data.subscription_plan_id];

    return (
      <div className='account-subscription-plan'>
        <div className='plan-header'>
          <span className='plan-currency'>
            {currency_symbol}
          </span>
          <h1 className='plan-price'>
            {amount/100}
          </h1>
          <span className='plan-duration'>
            /MONTH
          </span>
        </div>
        <hr className='line-bold'/>
        <div>
          <div className='plan-subheader'>
            Responses
          </div>
          <div className='plan-subheader'>
            Ideal for
          </div>
        </div>

        <div>
          <div className='plan-details-responses'>
            <p className='plan-responses-number'>
              {number_of_messages}
            </p>
            <span>
              /MO
            </span>
          </div>
          <div className='plan-details-recommendation'>
            <p className='plan-recommendation'>
              {description}
            </p>
          </div>
        </div>

        <div className='plan-subheader billing'>
          Billing Activity
        </div>
        <hr className='line-account-billing'/>
        <AccountInvoices/>
      </div>
    );
  }

  render() {
    return (
      <div className='col-xs-9 content-box'>
        {this.renderContent()}
      </div>
    )
  }
}

export default connect((state) => ({
  subscription: state.models.subscription,
  subscriptionPlans: state.models.subscriptionPlans,
}))(AccountSubscriptionPlan)
