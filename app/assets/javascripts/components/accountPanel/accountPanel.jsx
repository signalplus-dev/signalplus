import React, { Component } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { actions as appActions } from 'redux/modules/app.js';

// Components
import Sidebar from 'components/accountPanel/sidebar.jsx';

class AccountPanel extends Component {
  constructor(props) {
    super(props);
  }

  createTabIfNotCreated() {
    if (this.shouldCreateTab()) {
      const tab = {
        id: 'account',
        label: 'Account',
        link: '/dashboard/account',
        closeable: true,
      };

      this.props.dispatch(appActions.addTab(tab));
    };
  }

  findAccountTab() {
    const { tabs } = this.props;
    return (_.find(tabs, { id: 'account' }));
  }

  shouldCreateTab() {
    return (this.findAccountTab() ? false : true);
  }

  componentWillMount() {
    this.createTabIfNotCreated();
  }

  // cloneChildren() {
  //   const { brand, subscription } = this.props;
  //   return React.Children.map(this.props.children, (child) => {
  //     return React.cloneElement(child, { brand, subscription });
  //   });
  // }

  render() {
    const tabId = _.get(this.findAccountTab(), 'id', {});
    // const { children } = this.props;
    // const childrenToRender = children ? this.cloneChildren() : children;

    return (
      <div className="account-pane">
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

  // brand: state.models.brand,
  // subscription: state.models.subscription,
