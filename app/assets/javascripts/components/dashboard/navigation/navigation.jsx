import React, { Component } from 'react';
import { connect } from 'react-redux';
import { get } from 'lodash';
import restInterface from '../../../util/restInterface.js';
import { fetchListenSignalsData } from '../../../redux/modules/models/listenSignals.js';
import endpoints from '../../../util/endpoints.js';
import Tabs from './tabs.jsx';

class Navigation extends Component {
  constructor(props) {
    super(props);
    this.handleSignal   = this.handleSignal.bind(this);
  }

  componentWillMount() {
    const { listenSignals, dispatch } = this.props;
    if (!listenSignals.loaded) dispatch(fetchListenSignalsData());
  }

  handleSignal(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
  }

  render() {
    const { children, ...props } = this.props;

    return (
      <div>
        <Tabs />
        <div className='tab-content clearfix'>
          <div className="tab-pane dash-panel activeTab">
            {React.cloneElement(children, { ...props })}
          </div>
        </div>
      </div>
    );
  }
}

export default connect(state => ({
  listenSignals: get(state, 'listenSignals', {}),
}))(Navigation)
