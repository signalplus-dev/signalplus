import React, { Component } from 'react'
import { connect } from 'react-redux';
import { provideHooks } from 'redial';
import _ from 'lodash';
import commaNumber from 'comma-number';
import cn from 'classnames';
import StripeButton from './stripeButton.jsx';
import { getSubscriptionPlansData } from '../../redux/modules/models/subscriptionPlans.js'
import { getBrandData } from '../../redux/modules/models/brand.js'
import { createSubscription, updateSubscription } from '../../redux/modules/models/subscription.js'

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
    return <button className="btn selected-btn">SELECTED</button>;
  }

  renderActualButton(hasExistingSubscription) {
    const props = { className: "btn select-btn" };
    if (hasExistingSubscription) props.onClick = this.handleClick;

    return <button {...props}>SELECT</button>
  }

  renderUnseletedButton() {
    const { hasExistingSubscription } = this.props;

    if (hasExistingSubscription) {
      return this.renderActualButton(hasExistingSubscription)
    }

    return (
      <StripeButton handleToken={this.handleToken}>
        {this.renderActualButton(hasExistingSubscription)}
      </StripeButton>
    );
  }

  render() {
    const { selected } = this.props;

    return (
      <div className="btn-centered">
        {selected ? this.renderSelectedButton() : this.renderUnseletedButton()}
      </div>
    );
  }
}

class SubscriptionPlans extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
    this.state = {
      submitting: false,
    };
  }

  handleClick(formData) {
    const { dispatch } = this.props;
    if (this.hasExistingSubscription()) {
      dispatch(updateSubscription({
        ...formData,
        id: this.props.subscription.id,
      }));
    } else {
      dispatch(createSubscription(formData));
    }

    this.setState({ submitting: true });
  }

  hasExistingSubscription() {
    return !!_.get(this.props.subscription, 'subscription_plan_id');
  }

  renderSubscriptionPlans() {
    const { subscriptionPlans, subscription } = this.props;

    return _.map(subscriptionPlans, subscriptionPlan => {
      const subscriptionPlanId = _.get(subscription, 'subscription_plan_id');
      const selected = subscriptionPlanId === subscriptionPlan.id;

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

            <SelectButton
              selected={selected}
              subscriptionPlanId={subscriptionPlan.id}
              clickHandler={this.handleClick}
              hasExistingSubscription={this.hasExistingSubscription()}
            />
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

const ConnectedSubscriptionPlans = connect(state => ({
  subscription: state.models.subscription.data,
  subscriptionPlans: state.models.subscriptionPlans.data,
}))(SubscriptionPlans);

export default provideHooks(hooks)(ConnectedSubscriptionPlans)
