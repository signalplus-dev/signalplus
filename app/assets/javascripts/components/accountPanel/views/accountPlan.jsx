import React, { Component } from 'react';
import _ from 'lodash';
import InputBox from 'components/forms/inputBox.jsx';

export default class AccountPlan extends Component {

  render() {

    return (
      <div className='col-xs-9 content-box'>
        <div className='account-plan'>
          <div className='account-plan-header'>
            <h3 className='account-plan-header'>$XX/month</h3>
            <hr className='bline-bold'/>

          </div>

          <hr className='line'/>

          <div className='subscription-breakdown'>
            <p className='label'>Plan Name</p>
            <p className='price'>$x</p>
          </div>
          <div className='subscription-breakdown'>
            <p className='label'>Plan Name</p>
            <p className='price'>$x</p>
          </div>
          <div className='subscription-breakdown'>
            <p className='label'>Plan Name</p>
            <p className='price'>$x</p>
          </div>
          <p className='account-legend'>
            This will be charged to your XXXX card on the first of the month
          </p>
        </div>
      </div>
    );
  }
}
