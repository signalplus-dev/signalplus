import React, { Component } from 'react';
import WelcomePanel from './welcome_panel.jsx';
import ActiveSignalPanel from './active_signal_panel.jsx';
import CreateNew from './create_new.jsx';

export default class SignalsPane extends Component {
  renderPanelTitle() {
    var signalCount = this.props.signals.length
    if (signalCount == 0) {
      return 'All Signals'
    } else if (signalCount == 1) {
      return 'Signal - 1 Active'
    } else {
      return 'Signals - ' + signalCount + ' Active'
    }
  }

  choosePanel() {
    var signalCount = this.props.signals.length

    if (signalCount == 0) {
      return(<WelcomePanel/>)
    } else {
      return(<ActiveSignalPanel signals={this.props.signals}/>)
    }
  }

  render() {
    return (
      <div>
        <h4 className='signal-header'>{this.renderPanelTitle()}</h4>
        {this.choosePanel()}
        <CreateNew/>
      </div>
    );
  }
}
