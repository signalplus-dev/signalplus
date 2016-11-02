import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { actions as appActions } from 'redux/modules/app/index.js';

// Components
import Sidebar from 'components/accountPanel/sidebar.jsx';

class AccountPanel extends Component {
  createTabIfNotCreated() {
    if (this.shouldCreateTab()) {
      const tab = {
        id: 'account',
        label: 'Account',
        link: '/dashboard/account',
        closeable: true,
      };

      this.props.dispatch(appActions.addTab(tab));
    }
  }

  findAccountTab() {
    const { tabs } = this.props;
    return (_.find(tabs, { id: 'account' }));
  }

  shouldCreateTab() {
    if (!this._mounted) return false;
    return (this.findAccountTab() ? false : true);
  }

  componentDidMount() {
    this._mounted = true;
    this.createTabIfNotCreated();
  }

  componentWillUnmount() {
    this._mounted = false;
  }

  render() {
    const tabId = _.get(this.findAccountTab(), 'id', {});

    return (
      <div>
        <Sidebar tabId={tabId}/>
        <div className="content-pane">
          {this.props.children}
        </div>
      </div>
    );
  }
}

export default connect((state) => ({
  tabs: state.app.dashboard.tabs,
}))(AccountPanel);

