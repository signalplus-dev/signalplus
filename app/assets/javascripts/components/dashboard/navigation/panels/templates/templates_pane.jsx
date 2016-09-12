import React, { Component } from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';
import _ from 'lodash';

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
    this.props.handleSignal('editSignal', '');
    this.props.handleSignal('templateType', signalType);
  }

  renderTemplates() {
    return _.map(this.props.data.signal_types, (t, idx) => {
      return (
        <div onClick={() => this.handleClick(idx, t.type)} key={idx} className='panel signal-panel panel-new'>
          <SignalIcon type={t.type} className='panel-icon'/>
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
