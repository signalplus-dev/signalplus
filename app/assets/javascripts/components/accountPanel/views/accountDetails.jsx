import React, { Component } from 'react';
import _ from 'lodash';
import InputBox from 'components/forms/inputBox.jsx';

export default class AccountDetails extends Component {

  render() {

    return (

      <div className='col-xs-9 content-box'>
        <div className='account-details'>
          <p className='account-email-label'>Email Address</p>
          <p className='account-email-description'>
            We’ll notify you of changes to your account
          </p>
          <p> 
            CHECKBOX PLACE HOLDER Notify me of new features/product annoucements
          </p>

        <hr className='line'/>

          <p className='account-email-label'>
            Time Zone
          </p>
          <p className='account-email-description'>
            Set a default time zone for your account.  
            This will determine timing for your responses.
          </p>
        </div>
      </div>

    );
  }
}
