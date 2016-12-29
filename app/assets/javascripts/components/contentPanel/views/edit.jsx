import React, { Component } from 'react';
import { arrayPush, FieldArray } from 'redux-form';
import { connect } from 'react-redux';
import _ from 'lodash';
import InputBox from 'components/forms/inputBox';
import SignalIcon from 'components/links/signal_icon';
import TimedResponseForm from 'components/forms/timedResponseForm';
import { getFormNameFromSignal } from 'components/forms/util';

const DEFAULT_SIGNAL_NAME = 'Name';

class Edit extends Component {
  constructor(props) {
    super(props);
    this.addCustomResponse = this.addCustomResponse.bind(this);
  }

  displaySignalName() {
    const { signal, brand } = this.props;
    const signalName = signal.id ? signal.name : DEFAULT_SIGNAL_NAME;

    return (
      <h4 className='subheading'>@{brand.user_name} #{signalName}</h4>
    );
  }

  renderSubheader(type) {
    if (type == 'offers') {
      return 'Send your users a special offer everytime they send a custom hashtag'
    } else if (type == 'custom') {
      return 'Add your custom responses here, you can have responses expire on different dates. When you’re ready, activate your signal and promote it.'
    }
  }

  addCustomResponse() {
    const { dispatch, signal } = this.props;
    const form = getFormNameFromSignal(signal);

    dispatch(arrayPush(form, 'responses', { text: '', expiration_date: '' }));
  }

  renderDefaultDescription(type) {
    if (type == 'offers') {
      return 'Enter an offer that will run all the time or a welcome message'
    } else if (type == 'custom') {
      return 'Users will see this response the first time they use your signal'
    }
  }

  render() {
    const { signal } = this.props;

    return (
      <div className='col-xs-10 content-box'>
        <div className='content-header'>
          <SignalIcon type={signal.signal_type} className='content-icon' />
          <SignalIcon type='explanation' className='content-explanation' />
          <p className='signal-type-label'>TYPE</p>
          <h3 className='signal-type-header uctext'>{signal.signal_type} Signal</h3>
          <p className='signal-description'>
            {this.renderSubheader(signal.signal_type)}
          </p>
        </div>

        <hr className='line'/>

        <div className='response-info'>
          <h4>Responses to:</h4>
          <SignalIcon type="twitter" />
          {this.displaySignalName()}

          <div className='edit-btns'>
            <button
              type='button'
              onClick={this.addCustomResponse}
              className='btn btn-primary add-btn'
            >
              + ADD RESPONSE
            </button>
            <button
              type='submit'
              className='btn btn-primary save-btn'
            >
              SAVE
            </button>
          </div>
        </div>

        <div className='tip-box'>
          <SignalIcon type="tip"/>
          <h5>Tip</h5>
          <p> Add your offer responses here, be sure to include a link or details on how to use the offer.
              When you’re ready, activate your signal and promote it </p>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Default Response</h5>
            <p>{this.renderDefaultDescription(signal.signal_type)}</p>
          </div>
          <InputBox
            name="default_response"
            placeholder="Type in a response here, add website links too"
            componentClass="textarea"
          />
          <span className='required'>REQUIRED</span>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>
              Repeat Requests
            </h5>
            <p>Enter a thank you message for repeat requests</p>
          </div>
          <InputBox
            name="repeat_response"
            placeholder="Type in a response here, add website links too"
            componentClass="textarea"
          />
          <span className='required'>REQUIRED</span>
        </div>

        <FieldArray
          name='responses'
          component={TimedResponseForm}
        />
      </div>
    );
  }
}

export default connect()(Edit);
