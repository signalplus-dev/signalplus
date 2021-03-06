import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import _ from 'lodash';
import { provideHooks } from 'redial';
import { getListenSignalTemplatesData } from 'redux/modules/models/listenSignalTemplates.js'
import SignalIcon from 'components/links/signal_icon';

const hooks = {
  fetch: ({ dispatch }) => {
    dispatch(getListenSignalTemplatesData());
  },
};

function renderTemplates(templates) {
  return _.map(templates, (text, type) => {

    // Disable all signals except for offers and custom
    if (type == 'offers' || type == 'custom') {
      return (
        <Link to={`/dashboard/signals/new/${type}`} key={type} className='panel signal-panel panel-new'>
          <SignalIcon type={type} className='panel-icon'/>
          <div className={`panel-header ${type}`}>
            <div className='header-text uctext'>{type}</div>
            <div className='subheader'>SIGNAL</div>
          </div>
          <div className='panel-text'>{text}</div>
          <div className='panel-platform'>
            <p className='platform-label'>PLATFORM</p>
            <span className='platform-description'>
              <SignalIcon type='twitterGrey' className='logo'/>
              Twitter
            </span>
          </div>
        </Link>
      );
    }
  });
}

function TemplatesPane({ templates }) {
  return (
    <div>
      <h3 className='panel-label-text'>Create New Signal</h3>
      <p>Select a template to start </p>
      <div className='create-new'>
        {renderTemplates(templates)}

        <div className='panel signal-panel coming-soon'>
          <SignalIcon type='welcome' className='panel-icon'/>
          <div className='panel-header'>
            <div className='header-text uctext'>Coming Soon</div>
          </div>
          <div className='panel-text'>We’re adding new signal templates all the time. Stay tuned for more!</div>
        </div>
      </div>
    </div>
  );
}

const connectedTemplatesPane = connect(state => ({
  templates: _.get(state, 'models.listenSignalTemplates.data', {}),
}))(TemplatesPane);

export default provideHooks(hooks)(connectedTemplatesPane);
