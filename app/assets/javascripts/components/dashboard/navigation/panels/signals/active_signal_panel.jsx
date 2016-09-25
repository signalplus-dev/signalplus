import React, { Component } from 'react';
import { Link } from 'react-router';
import _ from 'lodash';
import SignalIcon from '../../../../links/signal_icon.jsx';
import { actions as appActions } from '../../../../../redux/modules/app.js';

function renderPanel(signals) {
  return _.map(signals, (s, signalId) => {
    return (
      <Link to={`/dashboard/signals/${signalId}`} className={`panel signal-panel ${s.signal_type}`} key={signalId}>
        <SignalIcon className='panel-icon' src={window.__IMAGE_ASSETS__[`icons${_.capitalize(s.signal_type)}Svg`]} />
        <div className='panel-header'>{`#${s.name}`}</div>
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
      </Link>
    );
  });
}

export default function ActiveSignalPanel({ signals }) {
  return <div>{renderPanel(signals)}</div>;
}

