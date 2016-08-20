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

    if (props.signal.edit) {
      var signal = props.signal.edit;
      var responses = signal.responses;
      this.state = {
        submitType:     'PUT',
        signalType:     signal.signal_type,
        name:           signal.name,
        active:         signal.active,
        firstResponse:  responses[0].message,
        repeatResponse: responses[1].message,
        expirationDate: signal.expiration_date,
      };
    } else if (props.signal.type) {
      var signal = props.signal.type;
      this.state = {
        submitType:     'POST',
        signalType:     signal,
        name:           signal,
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

  componentWillReceiveProps(nextProps) {
    var nextEdit = nextProps.signal.edit;
    var nextType = nextProps.signal.type;

    if (nextEdit && nextEdit != this.state) {
      this.setState({
        submitType:     'PUT',
        signalType:     nextEdit.signal_type,
        name:           nextEdit.name,
        firstResponse:  nextEdit.responses[0]['message'],
        repeatResponse: nextEdit.responses[1]['message'],
        active:         nextEdit.active,
        activeDate:     nextEdit.active_date,
        expirationDate: nextEdit.exp_date   
      });
    } else if ( nextType && nextType != this.state) {
      this.setState({
        submitType:     'POST',
        signalType:     nextType,
        name:           nextType,
        firstResponse:  'Type your response here',
        repeatResponse: 'Type your response here',
        active:         false,
        activeDate:     '',
        expirationDate: ''  
      });
    }
  }

  editSignalName() {
    if (this.props.signal.edit) {
      return (
        <h4 className='subheading'>@Brand #{this.state.name}</h4>
      );
    } else if (this.props.signal.type) {
      return (
        <h4 className='subheading'>@Brand #
         <InputBox 
            data={'Ex. ' + this.state.name} 
            setResponse={this.setResponse} 
            type='name' 
            componentClass='input'
            className='signal-name-edit uctext'
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
          <InputBox data={this.state.firstResponse} setResponse={this.setResponse} type='firstResponse'/>
          <span className='required'>REQUIRED</span>
        </div>

        <div className='response-edit-box'>
          <div className='response-text'>
            <h5>Not Available/ Repeat Requests</h5>
          </div>
          <InputBox data={this.state.repeatResponse} setResponse={this.setResponse} type='repeatResponse'/>
          <span className='required'>REQUIRED</span>
        </div>
      </div>
    );
  }
}


