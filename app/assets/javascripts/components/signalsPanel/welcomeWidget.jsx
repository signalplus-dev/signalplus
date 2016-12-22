import React from 'react';
import SignalIcon from 'components/links/signal_icon';

export default function WelcomeWidget() {
  return (
    <div className='panel signal-panel welcome'>
      <SignalIcon className='panel-icon' type='welcome' />
      <div className='panel-header'>Welcome</div>
      <div className='panel-text'>
        Start creating your own signals and responses or use our handy starter guide to learn more
      </div>
    </div>
  );
}
