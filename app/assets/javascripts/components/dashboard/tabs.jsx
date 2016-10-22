import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { Link, browserHistory } from 'react-router';
import { push } from 'react-router-redux';
import cn from 'classnames';
import { actions as appActions } from 'redux/modules/app/index.js';


const ACTIVE_SIGNAL_PATH = '/dashboard/signals/active'


class UnconnectedTabClose extends PureComponent {
  constructor(props) {
    super(props);
    this.closeTab = this.closeTab.bind(this);
  }

  closeTab(event) {
    event.preventDefault();
    event.stopPropagation();

    const { tab, tabs, dispatch } = this.props;
    const newPath = _.get(_.slice(tabs, -2, -1), '[0].link', ACTIVE_SIGNAL_PATH);

    dispatch(push(newPath))
      .then(() => dispatch(appActions.removeTab(tab.id)));
  }

  render() {
    return <button className='tab-close-btn' onClick={this.closeTab}>x</button>;
  }
}

const TabClose = connect()(UnconnectedTabClose);

function Tab({ tab, tabs, active }){
  return (
    <li>
      <Link activeClassName="active" to={tab.link}>{tab.label}
        {tab.closeable ? <TabClose tab={tab} tabs={tabs} /> : undefined }
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
        {...{ tab, tabs }}
      />
    );
  });

  return <ul className='nav nav-tabs'>{tabList}</ul>;
}

export default connect(state => ({
  tabs: state.app.dashboard.tabs,
  currentRoute: state.routing.locationBeforeTransitions.pathname,
}))(Tabs);
