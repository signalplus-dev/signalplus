import React from 'react'
import { connect } from 'react-redux';
import { provideHooks } from 'redial';
import _ from 'lodash';
import commaNumber from 'comma-number';
import { fetchSubscriptionPlansData } from '../../redux/modules/models/subscriptionPlans.js'

const hooks = {
  fetch: ({ dispatch }) => dispatch(fetchSubscriptionPlansData()),
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

function renderSubscriptionPlans(subscriptionPlans) {
  return _.map(subscriptionPlans.data, subscriptionPlan => {
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
          <div className="btn-centered">
            <button className="btn select-btn">SELECT</button>
          </div>
        </div>
      </div>
    );
  });
}

function SubscriptionPlans({ subscription, subscriptionPlans }) {
  return (
    <div>
      {renderSubscriptionPlans(subscriptionPlans)}
    </div>
  );
}

const ConnectedSubscriptionPlans = connect(state => ({
  subscription: state.models.subscription,
  subscriptionPlans: state.models.subscriptionPlans,
}))(SubscriptionPlans);

export default provideHooks(hooks)(ConnectedSubscriptionPlans)
