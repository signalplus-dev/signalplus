import React from 'react';
import { connect } from 'react-redux';
import { get } from 'lodash';
import Tabs from './tabs.jsx';

export default function Navigation({ children }) {
  return (
    <div>
      <Tabs />
      <div className='tab-content clearfix'>
        <div className="tab-pane dash-panel activeTab">
          {children}
        </div>
      </div>
    </div>
  );
}
