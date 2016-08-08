import React, { Component } from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';

export default class CreateNew extends Component {
  render() {
    return (
      <a href='#templates' data-toggle='tab'>
        <div className='panel signal-panel panel-new'>
          <SignalIcon src={window.__IMAGE_ASSETS__.iconsSignalplusSmallSvg} />

          <div className='panel-header header-new'>Create New</div>

          <div className='panel-body body-new'>
            Click here to create a new signal for your audience
          </div>
        </div>
      </a>
    );
  }
}
