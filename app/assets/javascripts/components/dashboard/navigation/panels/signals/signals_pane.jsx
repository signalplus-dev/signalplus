import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import WelcomePanel from './welcome_panel.jsx';
import ActiveSignalPanel from './active_signal_panel.jsx';
import CreateNew from './create_new.jsx';

class SignalsPane extends Component {
  renderPanelTitle() {
    const signalCount = _.keys(this.props.signals.data).length;

    if (signalCount) {
      return `Signals - ${signalCount} Active`;
    } else {
      return 'All Signals';
    }
  }

  choosePanel() {
    if (_.isEmpty(this.props.signals.data)) {
      return <WelcomePanel />;
    } else {
      return(
        <ActiveSignalPanel
          signals={this.props.signals}
          dispatch={this.props.dispatch}
        />
      );
    }
  }

  render() {
    return (
      <div>
        <h4 className='signal-header'>{this.renderPanelTitle()}</h4>
        {this.choosePanel()}
        <CreateNew
          handleClick={this.props.handleClick}
          handleSignal={this.props.handleSignal}
        />
      </div>
    );
  }
}

export default connect(state => ({
  signals: state.models.listenSignals,
}))(SignalsPane);
