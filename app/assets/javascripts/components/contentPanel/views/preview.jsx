import React from 'react'
import SignalIcon from 'components/links/signal_icon.jsx';
import _ from 'lodash';

export default function Preview(props) {
  const { signal, brand } = props;

  const getResponse = (type) => {
    const response = _.find(signal.responses, { response_type: type });
    return response.message;
  }

  if (signal.id) {
    return (
      <div className='col-xs-10 content-box'>
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
              @{brand.user_name} #{signal.name}
          </div>
          <span><SignalIcon className='preview-image' type="public"/></span>
        </div>

        <div className='row'>
          <div className='col-xs-1 preview-label' />
          <div className='col-xs-3 preview-label'>
            <h5>Default Response</h5>
            <h5 className='preview-wrap-text'>No Offers Available /Repeat Requests</h5>
            <h5>Custom Response</h5>
          </div>

          <div className='col-xs-5 preview-responses'>
            <div className='preview-response-bubble'>
              {getResponse('default')}
            </div>
            <div className='preview-response-bubble'>
              {getResponse('repeat')}
            </div>
            <div className='preview-response-bubble' />
          </div>
        </div>
      </div>
    );
  } else {
    return (
      <div className='col-xs-9 preview-error'>
        Create your signal first before previewing signal
      </div>);
  }
}


