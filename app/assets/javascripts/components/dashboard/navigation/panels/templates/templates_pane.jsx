import React, { Component } from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';

export default class TemplatesPane extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(idx, signalType) {
    const tab = {
      name: 'NEW',
      className: 'active',
      paneId: 'new'
    };

    this.props.handleTab(tab);
    this.props.handleSignal('templateType', signalType);
  }

  renderTemplates() {
    return this.props.signal_types.map((t, idx) => {
      return (
        <div onClick={() => this.handleClick(idx, t.type)} key={idx} className='panel signal-panel panel-new'>
          <SignalIcon src={window.__IMAGE_ASSETS__.iconsOfferPng} />
          <div className={'panel-header ' + t.type}>
            <div className='header-text uctext'>
              {t.type}
            </div>
            <div className='subheader'>
              SIGNAL
            </div>
          </div>
          <div className='panel-body'>
            {t.text}
          </div>
        </div>
      );
    });
  }

  render() {
    return (
      <div>
        <h3> Create New Signal</h3>
        <p> Select a template to start </p>
        <div className='create-new'>
          {this.renderTemplates()}
        </div>
      </div>
    );
  }
}
