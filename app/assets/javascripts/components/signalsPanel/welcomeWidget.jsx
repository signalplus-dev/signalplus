import React from 'react';
import SignalIcon from 'components/links/signal_icon.jsx';

export default function WelcomeWidget() {
  return (
    <div className='panel signal-panel welcome'>
      <SignalIcon src={window.__IMAGE_ASSETS__.iconsSignalplusSmallPinkSvg} className='panel-icon' />
      <div className='panel-header'>Welcome</div>
      <div className='panel-body'>
        Start creating your own signals and responses or use our handy starter guide to learn more
      </div>
    </div>
  );
}
