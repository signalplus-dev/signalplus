import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import _ from 'lodash';
import InputBox from 'components/forms/inputBox.jsx';


class UndecoratedAccountDetailsForm extends Component {
  constructor(props) {
    super(props);
    this.updateDetails = this.updateDetails.bind(this);
  }

  updateDetails(x){
    console.log(x);
  }

  render() {
    const { handleSubmit } = this.props;

    return (
      <form onSubmit={handleSubmit(this.updateDetails)}>
        <div className='col-xs-9 content-box'>
          <div className='account-details'>
            <p className='account-input-label'>Email Address</p>
            <p className='email-sublabel'>We’ll notify you of changes to your account</p>
            <InputBox
              name="twitter_admin_email"
              placeholder="Put your admin email address here"
              className='account-input-box'
            />
          </div>

          <div className='notification-checkbox'>
            Notify me of new features/product annoucements
          </div>

          <hr className='line'/>

          <div className='account-timezone'>
            <p className='account-input-label'>Time Zone</p>
            <p className='tz-sublabel'>Set a default time zone for your account.  This will determine timing for your responses.</p>
            <InputBox
              name="account_tz"
              placeholder="Put your signal timezone"
              className='account-input-box'
            />
          </div>
          <hr className='line'/>
          <button type='submit' className='btn btn-primary save-btn'>
            Save
          </button>
        </div>
      </form>
    );
  }
}

class AccountDetails extends Component {
  constructor(props) {
    super(props);
    console.log(props);
  }

  initializeValues() {
    return {
      initialValues: {
        twitter_admin_email: this.props.brand,
        account_tz: 'random tz',
      }
    }
  }

  render() {
    const initialValues = this.initializeValues();

    <UndecoratedAccountDetailsForm initialValues={initialValues} />
  }
}

export default reduxForm({
  form: 'accountDetails'
})(AccountDetails)

