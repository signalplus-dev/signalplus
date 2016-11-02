import React, { Component } from 'react';
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import _ from 'lodash';

// Components
import InputBox from 'components/forms/inputBox.jsx';
import Checkbox from 'components/forms/checkbox.jsx';
import TimezoneDropdown from 'components/forms/timezoneDropdown.jsx';
import { updateBrandAccountInfo } from 'redux/modules/models/brand.js';


class UndecoratedAccountInfo extends Component {
  constructor(props) {
    super(props);
    this.updateDetails = this.updateDetails.bind(this);
  }

  updateDetails({ ...form }){
    this.props.dispatch(updateBrandAccountInfo(form));
  }

  render() {
    const { handleSubmit } = this.props;

    return (
      <form onSubmit={handleSubmit(this.updateDetails)}>
        <div className='col-xs-10 content-box'>
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
            <Checkbox
              name="email_subscription"
              label='Notify me of new features/product annoucements'
            />
          </div>
          <hr className='line'/>
          <div className='account-timezone'>
            <p className='account-input-label'>Time Zone</p>
            <p className='tz-sublabel'>Set a default time zone for your account. This will determine timing for your responses.</p>
            <TimezoneDropdown
              name="tz"
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
  enableReinitialize: true,
})(UndecoratedAccountInfo)

export default connect((state) => {
  return {
    initialValues: {
      twitter_admin_email: state.models.brand.data.twitter_admin_email,
      email_subscription: state.models.brand.data.email_subscription,
      tz: state.models.brand.data.tz,
    },
  };
})(AccountInfo);


