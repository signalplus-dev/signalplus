import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import _ from 'lodash';
import { provideHooks } from 'redial';
import { getListenSignalTemplatesData } from 'redux/modules/models/listenSignalTemplates.js'


// Components
import SignalIcon from 'components/links/signal_icon.jsx';

const hooks = {
  fetch: ({ dispatch }) => {
    dispatch(getListenSignalTemplatesData());
  },
};

function renderTemplates(templates) {
  return _.map(templates, (text, type) => {
    return (
      <Link to={`/dashboard/signals/new/${type}`} key={type} className='panel signal-panel panel-new'>
        <SignalIcon type={type} className='panel-icon'/>
        <div className={`panel-header ${type}`}>
          <div className='header-text uctext'>{type}</div>
          <div className='subheader'>SIGNAL</div>
        </div>
        <div className='panel-body'>{text}</div>
      </Link>
    );
  });
}

function TemplatesPane({ templates }) {
  return (
    <div>
      <h3>Create New Signal</h3>
      <p>Select a template to start </p>
      <div className='create-new'>
        {renderTemplates(templates)}
      </div>
    </div>
  );
}

const connectedTemplatesPane = connect(state => ({
  templates: _.get(state, 'models.listenSignalTemplates.data', {}),
}))(TemplatesPane);

export default provideHooks(hooks)(connectedTemplatesPane);
