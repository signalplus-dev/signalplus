import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import commaNumber from 'comma-number';
import { actions as appActions } from 'redux/modules/app/index';
import { updateSubscription } from 'redux/modules/models/subscription';

// Component
import Loader from 'components/loader';
import InputBox from 'components/forms/inputBox';
import AccountInvoices from 'components/accountPanel/views/accountInvoices';

import { CANCEL_SUBSCRIPTION } from 'components/modals/modalConstants';

class AccountSubscriptionPlan extends Component {
  constructor(props){
    super(props);
    this.confirmCancelSubscription = this.confirmCancelSubscription.bind(this);
    this.reactivateSubscription = this.reactivateSubscription.bind(this);
  }

  confirmCancelSubscription() {
    const { dispatch, subscription } = this.props;

    dispatch(appActions.showModal({
      modalType: CANCEL_SUBSCRIPTION,
      modalProps: {
        subscription: subscription.data,
      }
    }));
  }

  reactivateSubscription() {
    const { dispatch, subscription } = this.props;
    const { id, subscription_plan_id } = subscription.data
    const formData = { id, subscription_plan_id }
    dispatch(updateSubscription(formData));
  }

  renderSubscriptionAction() {
    const { subscription } = this.props;
    const { canceled_at } = subscription.data;

    if (!canceled_at) {
      return (
        <div className='plan-cancel'>
          <button onClick={this.confirmCancelSubscription} className='btn cancel-btn' >
            CANCEL YOUR PLAN
          </button>
          <p className='plan-cancel-subtext'>
            Select to cancel your current plan.  <br/>
            We’ll confirm your plan cancellation.
          </p>
        </div>
      );
    }

    return (
      <div className='plan-cancel'>
        <button onClick={this.reactivateSubscription} className='btn btn-green' >
            REACTIVATE YOUR PLAN
          </button>
          <p className='plan-cancel-subtext'>
            If you are reactivating before the end of the billing cycle ,<br/>
            you're billing date will remain the same. Otherwise, your new billing<br />
            date will be the day you reactivate your subscription.
          </p>
      </div>
    );
  }

  renderContent() {
    const { subscription, subscriptionPlans } = this.props;

    if (!subscription.loaded || !subscriptionPlans.loaded) return <Loader/>;

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
            /MO
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
              {commaNumber(number_of_messages)}
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

        <hr className='line-account-cancel'/>
        {this.renderSubscriptionAction()}
      </div>
    );
  }

  render() {
    return (
      <div className='col-xs-10 content-box'>
        {this.renderContent()}
      </div>
    )
  }
}

export default connect((state) => ({
  subscription: state.models.subscription,
  subscriptionPlans: state.models.subscriptionPlans,
}))(AccountSubscriptionPlan)
