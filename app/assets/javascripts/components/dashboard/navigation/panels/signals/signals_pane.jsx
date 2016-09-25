import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import WelcomePanel from './welcome_panel.jsx';
import ActiveSignalPanel from './active_signal_panel.jsx';
import CreateNew from './create_new.jsx';

class SignalsPane extends Component {
  renderPanelTitle() {
    const signalCount = _.keys(this.props.signals).length;

    if (signalCount) {
      return `Signals - ${signalCount} Active`;
    } else {
      return 'All Signals';
    }
  }

  choosePanel() {
    if (_.isEmpty(this.props.signals)) {
      return <WelcomePanel />;
    } else {
      return <ActiveSignalPanel signals={this.props.signals} />;
    }
  }

  render() {
    return (
      <div>
        <h4 className='signal-header'>{this.renderPanelTitle()}</h4>
        {this.choosePanel()}
        <CreateNew />
      </div>
    );
  }
}

export default connect(state => ({
  signals: _.get(state, 'models.listenSignals.data'),
}))(SignalsPane);
