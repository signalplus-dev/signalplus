import React, { Component } from 'react';
import { connect } from 'react-redux';
import { get } from 'lodash';
import restInterface from '../../../util/restInterface.js';
import { fetchListenSignalsData } from '../../../redux/modules/models/listenSignals.js';
import endpoints from '../../../util/endpoints.js';
import Panes from './panes.jsx';
import Tabs from './tabs.jsx';

class Navigation extends Component {
  constructor(props) {
    super(props);
    this.handleTabs     = this.handleTabs.bind(this);
    this.handleTabClick = this.handleTabClick.bind(this);
    this.handleSignal   = this.handleSignal.bind(this);
    this.state = {
      tabList: [
        {
          id: 1,
          name: 'SIGNALS',
          paneId: 'signals',
          active: true,
        },
        {
          id: 2,
          name: 'CREATE NEW',
          paneId: 'templates',
          active: false,
        }
      ],
      editSignal: '',
      templateType: '',
    };
  }

  componentWillMount() {
    const { listenSignals, dispatch } = this.props;
    if (!listenSignals.loaded) dispatch(fetchListenSignalsData());
  }

  handleTabs(tab) {
    const newTabs = [
      {
        id: 1,
        name: 'SIGNALS',
        paneId: 'signals',
        active: false,
      },
      {
        id: 2,
        name: 'CREATE NEW',
        paneId: 'templates',
        active: false,
      }
    ];

    newTabs.push({
      id: newTabs.length + 1,
      name: tab.name,
      paneId: tab.paneId,
      active: true,
    });

    this.setState({tabList: newTabs})
  }

  handleSignal(key, value) {
    var obj = {};
    obj[key] = value;
    this.setState(obj);
  }

  handleTabClick(tabId) {
    const newTabs = this.state.tabList.map((t) => {
      t.active = t.id == tabId;
      return t;
    });

    this.setState({ tabList: newTabs });
  }

  render() {
    const { children, ...props } = this.props;

    return (
      <div>
        <Tabs
          tabs={this.state.tabList}
          handleClick={this.handleTabClick}
        />
        <div className='tab-content clearfix'>
          <div className="tab-pane dash-panel activeTab">
            {React.cloneElement(children, { ...props })}
          </div>
        </div>
        {/*<Panes
          tabs={this.state.tabList}
          data={this.state.signals}
          handleClick={this.handleTabClick}
          handleTab={this.handleTabs}
          handleSignal={this.handleSignal}
          templateType={this.state.templateType}
          editSignal={this.state.editSignal}
        />*/}
      </div>
    );
  }
}

export default connect(state => ({
  listenSignals: get(state, 'listenSignals', {}),
}))(Navigation)
