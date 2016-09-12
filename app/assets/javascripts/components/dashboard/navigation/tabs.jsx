import React from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { Link, withRouter } from 'react-router';
import cn from 'classnames';


function Tab({ tab, active }){
  return (
    <li className={cn({ active })}>
      <Link to={tab.link}>{tab.label}</Link>
    </li>
  );
}

function Tabs({ tabs, currentRoute }) {
  const tabList = _.map(tabs, (tab) => {
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
