import React from 'react';

function getIcon(type) {
  const iconTypes = {
    offer:       window.__IMAGE_ASSETS__.iconsOfferSvg,
    contest:     window.__IMAGE_ASSETS__.iconsContestSvg,
    today:       window.__IMAGE_ASSETS__.iconsTodaySvg,
    reminder:    window.__IMAGE_ASSETS__.iconsReminderSvg,
    welcome:     window.__IMAGE_ASSETS__.iconsSignalplusSmallPinkSvg,
    create:      window.__IMAGE_ASSETS__.iconsSignalplusSmallSvg,
    tip:         window.__IMAGE_ASSETS__.iconsTipIconSvg,
    public:      window.__IMAGE_ASSETS__.iconsPublicIconSvg,
    explanation: window.__IMAGE_ASSETS__.iconsExplanationPng,
    twitter:     window.__IMAGE_ASSETS__.socialTwitterBlueSvg,
    arrow:       window.__IMAGE_ASSETS__.iconsBlueArrowPng,
  };

  return iconTypes[type];
}

export default function SignalIcon(props) {
  const src = props.src || getIcon(props.type);

  return (
    <img src={props.src} className='panel-icon' />
  );
}
