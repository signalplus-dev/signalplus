import React, { Component } from 'react';
import _ from 'lodash';
import SignalIcon from '../../../../links/signal_icon.jsx';

export default class ActiveSignalPanel extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(idx) {
    const tab = {
      name: 'Edit',
      className: 'active',
      paneId: 'new',
    };

    this.props.handleTab(tab);
    this.props.handleSignal('editSignal', this.props.signals[idx]);
  }

  renderPanel() {
    return this.props.signals.map((s, idx) => {
      return (
        <div onClick={() => this.handleClick(idx)} className={`panel signal-panel ${s.signal_type}`} key={idx} >
          <SignalIcon className='panel-icon' src={window.__IMAGE_ASSETS__[`icons${_.capitalize(s.signal_type)}Svg`]} />
          <div className='panel-header'>{'# ' + s.name}</div>
          <div className='panel-body'>Send your users a special offer every time they send a custom hashtag</div>

          <div className='panel-status'>
            <div className='signal-status'>
              <div className='circle active'></div>
              <span className='status'>ACTIVE</span>
            </div>
          </div>

          <div className='signal-type'>
            <p>TYPE</p>
            <span className='uctext type'>{s.signal_type}</span>
          </div>
        </div>
      );
    });
  }

  render() {
    return <div>{this.renderPanel()}</div>;
  }
}
