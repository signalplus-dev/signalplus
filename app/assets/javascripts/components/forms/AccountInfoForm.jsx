import React, { Component } from 'react';
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import _ from 'lodash';
import InputBox from 'components/forms/inputBox.jsx';


class AccountInfoForm extends Component {
  constructor(props) {
    super(props);
    console.log(props);
    this.updateDetails = this.updateDetails.bind(this);
  }

  updateDetails(x){
    console.log(x);
  }

  render() {
    const { handleSubmit } = this.props;

    return (
      <form>
        <div className='col-xs-9 content-box'>
          <div className='account-details'>
            <p className='account-input-label'>Email Address</p>
            <p className='email-sublabel'>We’ll notify you of changes to your account</p>
            <InputBox
              name="twitter_admin_email"
              placeholder="ie. john@signalplus.com"
              className='account-input-box'
              componentClass="input"
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
              placeholder="ie. US/EST"
              className='account-input-box'
              componentClass="input"
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

const AccountInfoForm = reduxForm({
  form: 'accountDetails',
})

export default connect((state) => {
  return {
    initialValues: {
      twitter_admin_email: state.models.brand.data.twitter_admin_email,
      account_tz: 'x',
    }
  }
})(AccountInfoForm);


