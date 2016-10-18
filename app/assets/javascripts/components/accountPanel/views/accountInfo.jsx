import React, { Component } from 'react';
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import _ from 'lodash';

// Components
import InputBox from 'components/forms/inputBox.jsx';
import CheckBox from 'components/forms/checkBox.jsx';
import { updateBrandTwitterAdminEmail } from 'redux/modules/models/brand.js';

class UndecoratedAccountInfo extends Component {
  constructor(props) {
    super(props);
    this.updateDetails = this.updateDetails.bind(this);
  }

  updateDetails({ ...form }){
    this.props.dispatch(updateBrandTwitterAdminEmail(form));
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
              placeholder="ie. john@signalplus.com"
              className='account-input-box'
              componentClass="input"
            />
          </div>
          <div className='notification-checkbox'>
            <CheckBox
              name="email_subscription"
              className='account-checkbox'
              label='Notify me of new features/product annoucements'
            />
          </div>
          <hr className='line'/>
          <div className='account-timezone'>
            <p className='account-input-label'>Time Zone</p>
            <p className='tz-sublabel'>Set a default time zone for your account.  This will determine timing for your responses.</p>
            <InputBox
              name="tz"
              placeholder="ie. US/EST"
              className='account-input-box'
              componentClass="input"
            />
          </div>
          <hr className='line'/>
          <button className='btn btn-primary save-btn'>
            Save
          </button>
        </div>
      </form>
    );
  }
}

const AccountInfo = reduxForm({
  form: 'accountInfo',
})(UndecoratedAccountInfo)

export default connect((state) => {
  // State is present but not initializing with the values here
  return {
    initialValues: {
      twitter_admin_email: state.models.brand.data.twitter_admin_email,
      tz: state.models.brand.data.tz,
      email_subscription: true,
    }
  }
})(AccountInfo);


