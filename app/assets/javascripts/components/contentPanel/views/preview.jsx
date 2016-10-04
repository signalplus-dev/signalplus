import React from 'react'
import SignalIcon from 'components/links/signal_icon.jsx';

export default function Preview(props) {
  const signal = props.signal.edit;

  if (signal) {
    return (
      <div className='col-xs-9 content-box'>
        <div className='content-header'>
          <p className='signal-type-label'>REQUEST > RESPONSE</p>
        </div>

        <div className='response-info'>
          <SignalIcon src={window.__IMAGE_ASSETS__.socialTwitterBlueSvg} />
          <h4>Public Tweet or Direct Message</h4>
          <SignalIcon
            className="arrow"
            src={window.__IMAGE_ASSETS__.iconsBlueArrowPng}
            />
          <h4 className='subheading'>Direct Message</h4>
        </div>

        <div className='preview-bubble'>
          <div className='bubble'>
              @{signal['brand_name']} #{signal['name']}
          </div>
          <span><SignalIcon className='preview-image' type="public"/></span>
        </div>

        <div className='row'>
          <div className='col-md-1 preview-label' />
          <div className='col-md-3 preview-label'>
            <h5>First Response</h5>
            <h5 className='preview-wrap-text'>No Offers Available /Repeat Requests</h5>
            <h5>Timed Offer</h5>
            <h5>Range Offer</h5>
          </div>

          <div className='col-md-5 preview-responses'>
            <div className='preview-response-bubble'>
              {signal.responses[0].message}
            </div>
            <div className='preview-response-bubble'>
              {signal.responses[1].message}
            </div>
            <div className='preview-response-bubble' />
            <div className='preview-response-bubble' />
          </div>
        </div>
      </div>
    );
  } else {
    return (
      <div className='col-md-9 preview-error'>
        Create your signal first before previewing signal
      </div>);
  }
}


