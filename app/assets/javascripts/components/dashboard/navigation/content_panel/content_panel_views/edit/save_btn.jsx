import React, { Component } from 'react';
import { connect } from 'react-redux';
import { addListenSignalData } from '../../../../../../redux/modules/models/listenSignals.js';


export class SaveBtn extends Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit() {
    this.createSignal(this.props.signal);
  }

  createSignal(signal) {
    const payload = {
      listen_signal: {
        id:               signal.id,
        name:             signal.name,
        signal_type:      signal.signalType,
        active:           signal.active,
        expiration_date:  signal.expirationDate,
      },
      responses: {
        first_response:   signal.firstResponse,
        repeat_response:  signal.repeatResponse,
        expiration_date:  signal.expirationDate,
      },
    };

    this.props.dispatch(addListenSignalData(payload));
  }

  render() {
    return (
      <div className='edit-btns'>
        <button
          type='submit'
          className='btn btn-primary save-btn'
        >
          SAVE
        </button>
      </div>
    );
  }
}

export default connect()(SaveBtn);
