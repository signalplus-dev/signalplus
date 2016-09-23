import React, { Component } from 'react';
import _ from 'lodash';
import Calendar from './calendar.jsx';
import InputBox from './input_box.jsx';
import SaveBtn from './save_btn.jsx';
import AddBtn from './add_btn.jsx';
import SignalIcon from '../../../../../links/signal_icon.jsx';

export default class Edit extends Component {
  constructor(props) {
    super(props);

    this.setResponse = this.setResponse.bind(this);
    this.editSignalName = this.editSignalName.bind(this);

    const signal = props.signal;

    if (props.signal.id) {
      const responses = signal.responses;

      this.state = {
        submitType:     'PUT',
        id:             signal.id, 
        signalType:     signal.signal_type,
        name:           signal.name,
        active:         signal.active,
        firstResponse:  signal.responses[0].message,
        repeatResponse: signal.responses[1].message,
        expirationDate: signal.expiration_date,
      };
    } else {
      this.state = {
        submitType:     'POST',
        signalType:     signal.type,
        name:           _.upperFirst(signal.type),
        active:         false,
        firstResponse:  'Type your response here',
        repeatResponse: 'Type your response here',
        expirationDate: ''
      };
    }
  }
  
  setResponse(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
  }

  editSignalName() {
    if (this.props.signal.id) {
      return (
        <h4 className='subheading'>@Brand #{this.state.name}</h4>
      );
    } else {
      return (
        <h4 className='subheading'>@Brand #
         <InputBox 
            setResponse={this.setResponse} 
            type='name' 
            componentClass='input'
            className='signal-name-edit uctext'
            placeholder={'Ex. '+ this.state.signalType} 
          />
        </h4>
      );
    } 
  }

  render() {
    return (
      <div className='col-md-9 content-box'>
        <div className='content-header'>
          <SignalIcon type={this.state.signalType} className='content-icon' />
          <SignalIcon type='explanation' className='content-explanation' />
          <p className='signal-type-label'>TYPE</p>
          <h3 className='signal-type-header uctext'>{this.state.signalType} Signal</h3>
          <p className='signal-description'>
            Send your users a special offer everytime they send a custom hashtag
          </p>
        </div>

        <hr className='line'/>

        <div className='response-info'>
          <h4>Responses to:</h4>
          <SignalIcon type="twitter" />
          { this.editSignalName() }
          <SaveBtn data={ this.state }/>
          <AddBtn type='add' 
            setResponse={this.setResponse} 
            expirationDate={this.state.expirationDate}/>
        </div>

        <div className='tip-box'>
          <SignalIcon type="tip"/>
          <h5>Tip</h5>
          <p> Add your offer responses here, be sure to include a link or details on how to use the offer.
              When you’re ready, activate your signal and promote it </p>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>First Response</h5>
            <p>Users will see this response the first time they use your signal</p>
          </div>
          <InputBox 
            data={this.state.firstResponse} 
            setResponse={this.setResponse} 
            type='firstResponse'
            componentClass='textarea'
            placeholder='Type your response here'
          />
          <span className='required'>REQUIRED</span>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Not Available/ Repeat Requests</h5>
          </div>
          <InputBox 
            data={this.state.repeatResponse} 
            setResponse={this.setResponse} 
            type='repeatResponse'
            componentClass='textarea'
            placeholder='Type your response here'
          />
          <span className='required'>REQUIRED</span>
        </div>
      </div>
    );
  }
}

