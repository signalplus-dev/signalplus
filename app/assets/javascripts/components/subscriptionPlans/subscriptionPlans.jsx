import React, { Component } from 'react'
import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import _ from 'lodash';
import commaNumber from 'comma-number';
import cn from 'classnames';

import { createSubscription, updateSubscription } from 'redux/modules/models/subscription'
import { clearTA } from 'util/authentication';

import StripeButton from 'components/subscriptionPlans/stripeButton';

const hooks = {
  fetch: ({ dispatch }) => {
    dispatch(getSubscriptionPlansData());
    dispatch(getBrandData());
  },
};

function renderAmount(subscriptionPlan) {
  if (subscriptionPlan.amount === 0) {
    return <span className="plan-price">FREE</span>;
  }

  return (
    <div>
      <span className="currency-symbol">{subscriptionPlan.currency_symbol}</span>
      <span className="plan-price">{subscriptionPlan.amount / 100}</span>
      <span className="per-month">/MO</span>
    </div>
  );
}

function numberOfMessages(subscriptionPlan) {
  const numMessages = commaNumber(subscriptionPlan.number_of_messages);
  const free = subscriptionPlan.amount === 0;

  return (
    <div className="plan-responses">
      <div><strong>Responses</strong></div>
      <span className="plan-message-amount">{numMessages}</span>
      {free ? undefined : <span className="per-month">/MO</span>}
    </div>
  );
}

function renderDetailText(subscriptionPlan) {
  if (subscriptionPlan.amount === 0) {
    return (<div className="plan-description">{subscriptionPlan.description}</div>)
  }

  return (
    <div>
      <div><strong>Ideal for</strong></div>
      <div className="plan-description">{subscriptionPlan.description}</div>
    </div>
  );
}

class SelectButton extends Component {
  constructor(props) {
    super(props);
    this.handleToken = this.handleToken.bind(this);
    this.handleClick = this.handleClick.bind(this);
  }

  handleToken(stripeTokenData) {
    event.preventDefault();
    const { subscriptionPlanId: subscription_plan_id } = this.props;
    this.props.clickHandler({
      subscription_plan_id,
      stripe_token: stripeTokenData.id,
      email: stripeTokenData.email,
    });
  }

  handleClick() {
    const { subscriptionPlanId: subscription_plan_id } = this.props;
    this.props.clickHandler({ subscription_plan_id });
  }

  renderSelectedButton() {
    const text = this.props.canceled ? 'REACTIVATE PLAN' : 'CURRENT PLAN';
    return <button className="btn selected-btn">{text}</button>;
  }

  renderActualButton() {
    const { hasExistingSubscription, selected, canceled } = this.props;
    const classes = cn({
      btn: true,
      'select-btn': !selected,
      'selected-btn': selected,
      'selected-btn-canceled': selected && canceled,
    });
    const props = { className: classes };
    if (hasExistingSubscription) props.onClick = this.handleClick;
    const text = selected ? (canceled ? 'REACTIVATE PLAN' : 'CURRENT PLAN') : 'SELECT';
    return <button {...props}>{text}</button>
  }

  renderButton() {
    const { hasExistingSubscription } = this.props;

    if (hasExistingSubscription) {
      return this.renderActualButton()
    }

    return (
      <StripeButton handleToken={this.handleToken}>
        {this.renderActualButton()}
      </StripeButton>
    );
  }

  render() {
    const { selected } = this.props;

    return (
      <div className="btn-centered">
        {this.renderButton()}
      </div>
    );
  }
}

export class SubscriptionPlans extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
    this.state = {
      submitting: false,
    };
  }

  handleClick(formData) {
    this.setState({ submitting: true });
    const { dispatch, hasExistingSubscription } = this.props;
    let promise;
    if (hasExistingSubscription) {
      dispatch(updateSubscription({
        ...formData,
        id: this.props.subscriptionId,
      })).then((response) => {
        browserHistory.push('/dashboard');
      });;
    } else {
      dispatch(createSubscription(formData)).then((response) => {
        clearTA();
        window.location = '/dashboard';
      });
    }
  }

  renderSelectButton(subscriptionPlan) {
    const { inDashboard, hasExistingSubscription, canceled } = this.props;

    if (inDashboard) {
      return (
        <SelectButton
          selected={subscriptionPlan.selected}
          subscriptionPlanId={subscriptionPlan.id}
          clickHandler={this.handleClick}
          hasExistingSubscription={hasExistingSubscription}
          canceled={canceled}
        />
      );
    }

    return undefined;
  }

  renderSubscriptionPlans() {
    const { subscriptionPlans } = this.props;

    return _.map(subscriptionPlans, (subscriptionPlan) => {
      return (
        <div className="plan-box" key={`subscriptionPlan_id_${subscriptionPlan.id}`}>
          <div className="box-header">{subscriptionPlan.name}</div>
          <div className="box-content">
            <div className="price-details">
              {renderAmount(subscriptionPlan)}
              <hr/>
            </div>
            <div className="plan-details">
              {numberOfMessages(subscriptionPlan)}
              <div className="detail-text">
                {renderDetailText(subscriptionPlan)}
              </div>
            </div>
            {this.renderSelectButton(subscriptionPlan)}
          </div>
        </div>
      );
    });
  }

  render() {
    return (
      <div className="plan-boxes">
        {this.renderSubscriptionPlans()}
      </div>
    );
  }
}

export default connect(state => {
  const subscription = state.models.subscription.data;
  const { id, subscription_plan_id, canceled_at } = subscription;
  const subscriptionPlans = state.models.subscriptionPlans.data;

  return {
    inDashboard: true,
    hasExistingSubscription: !!subscription_plan_id,
    subscriptionId: id,
    canceled: !!canceled_at,
    subscriptionPlans: _.reduce(subscriptionPlans, (memo, subscriptionPlan) => ([
      ...memo,
      {
        ...subscriptionPlan,
        selected: subscriptionPlan.id === subscription_plan_id,
      },
    ]), []),
  };
})(SubscriptionPlans);
