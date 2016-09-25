import React from 'react';
import SignalIcon from '../../../../links/signal_icon.jsx';
import { Link } from 'react-router';

export default function CreateNew() {
  return (
    <Link to="/dashboard/templates">
      <div className='panel signal-panel panel-new'>
        <SignalIcon type='create' className='panel-icon'/>
        <div className='panel-header header-new'>
          Create New
        </div>
        <div className='panel-body body-new'>
          Click here to create a new signal for your audience
        </div>
      </div>
    </Link>
  );
}
