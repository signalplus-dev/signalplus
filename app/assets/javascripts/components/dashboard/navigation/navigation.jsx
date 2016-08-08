import React, { Component } from 'react'
import ReactDOM from 'react-dom';
import Panes from './panes.jsx';
import Tabs from './tabs.jsx';

export default class Navigation extends Component {
  constructor(props) {
    super(props);
    this.handleTabs = this.handleTabs.bind(this);
    this.handleTabClick = this.handleTabClick.bind(this);
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
      ]
    };
  }

  handleTabs(tab) {
    var newTabs = this.state.tabList.map(function(t) {
      t.active = false
      return t
    });

    newTabs.push(
      {
        id: newTabs.length + 1,
        name: tab.name,
        paneId: tab.paneId,
        active: true,
      }
    );

    this.setState({tabList: newTabs})
  }

  handleTabClick(tabId) {
    var newTabs = this.state.tabList.map(function(t) {
      t.active = t.id == tabId;
      return t;
    });

    this.setState({ tabList: newTabs });
  }

  render() {
    return (
      <div>
        <Tabs tabs={this.state.tabList} handleClick={this.handleTabClick} />
        <Panes tabs={this.state.tabList} data={this.props.data} handleTab={this.handleTabs}/>
      </div>
    );
  }
}
