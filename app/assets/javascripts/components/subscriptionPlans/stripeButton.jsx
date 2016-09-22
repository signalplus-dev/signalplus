import React, { PureComponent } from 'react'
import StripeCheckout from 'react-stripe-checkout';

export default class StripeButton extends PureComponent {
  constructor(props) {
    super(props);
    this.onToken = this.onToken.bind(this);
  }

  onToken(token) {
    this.props.handleToken(token);
  }

  render() {
    return (
      <StripeCheckout
        name="Signal Plus"
        image={window.__IMAGE_ASSETS__.logoSignalplusIconPng}
        amount={this.props.amount}
        currency="USD"
        token={this.onToken}
        stripeKey="pk_test_UKOJQ8pCePrRMbqJbnY2oBjY" // Make this more dynamic
      >
        {this.props.children}
      </StripeCheckout>
    );
  }
}
