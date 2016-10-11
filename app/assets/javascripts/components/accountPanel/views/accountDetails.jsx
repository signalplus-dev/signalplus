import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';
import _ from 'lodash';
import InputBox from 'components/forms/inputBox.jsx';

class AccountDetails extends Component {

  render() {
    const { handleSubmit } = this.props;

    return (
      <form onSubmit={handleSubmit}>
        <div className='col-xs-9 content-box'>
          <div className='account-details'>
            <label className='account-email-label'>
              Email Address <br/>
              We’ll notify you of changes to your account
            </label>

            <InputBox
              name="account-email"
              placeholder="email"
            />
          </div>

          <div>
            CHECKBOX PLACE HOLDER Notify me of new features/product annoucements
          </div>

          <hr className='line'/>

          <div>
            <label className='account-email-label'> 
              Time Zone <br/>
              Set a default time zone for your account.  
              This will determine timing for your responses.
            </label>
            <Field name='account-email' component='input' type='text'/>
          </div>
        </div>
      </form>
    );
  }
}

export default reduxForm({
  form: 'accountDetails'
})(AccountDetails)
