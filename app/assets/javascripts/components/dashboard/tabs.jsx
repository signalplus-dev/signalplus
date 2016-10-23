import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { Link, browserHistory } from 'react-router';
import cn from 'classnames';
import { actions as appActions } from 'redux/modules/app/index.js';


const ACTIVE_SIGNAL_PATH = '/dashboard/signals/active'


class UnconnectedTabClose extends PureComponent {
  constructor(props) {
    super(props);
    this.closeTab = this.closeTab.bind(this);
  }

  closeTab(event) {
    const { tab, dispatch } = this.props;

    event.preventDefault();
    event.stopPropagation();

    dispatch(appActions.removeTab(tab.id));
    browserHistory.push(ACTIVE_SIGNAL_PATH)
  }

  render() {
    return <button className='tab-close-btn' onClick={this.closeTab}>x</button>;
  }
}

const TabClose = connect()(UnconnectedTabClose);

function Tab({ tab, active }){
  return (
    <li>
      <Link activeClassName="active" to={tab.link}>{tab.label}
        {tab.closeable ? <TabClose tab={tab} /> : undefined }
      </Link>
    </li>
  );
}

function Tabs({ tabs, currentRoute }) {
  const tabList = _.map(tabs, tab => {
    return (
      <Tab
        key={tab.id}
        active={tab.link === currentRoute}
        {...{ tab }}
      />
    );
  });

  return <ul className='nav nav-tabs'>{tabList}</ul>;
}

export default connect(state => ({
  tabs: state.app.dashboard.tabs,
  currentRoute: state.routing.locationBeforeTransitions.pathname,
}))(Tabs);
