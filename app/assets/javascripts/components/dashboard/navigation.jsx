import React from 'react';
import { connect } from 'react-redux';
import { get } from 'lodash';
import Tabs from 'components/dashboard/tabs';

export default function Navigation({ children }) {
  return (
    <div>
      <Tabs />

      <div className="panel-content">
        <div className="container-fluid">
          <div className="row">
            <div className="col-xs-12">
              <div className='tab-content clearfix'>
                {children}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
