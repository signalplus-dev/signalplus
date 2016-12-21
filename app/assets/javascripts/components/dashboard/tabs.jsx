import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import { Link, withRouter  } from 'react-router';
import { push } from 'react-router-redux';
import cn from 'classnames';
import { actions as appActions } from 'redux/modules/app/index';
import { destroy } from 'redux-form';

import SVGInline from 'react-svg-inline';
import svg from 'icons/close.svg';


const ACTIVE_SIGNAL_PATH = '/dashboard/signals/active'


class UnconnectedTabClose extends PureComponent {
  constructor(props) {
    super(props);
    this.closeTab = this.closeTab.bind(this);
  }

  closeTab(event) {
    event.preventDefault();
    event.stopPropagation();

    const { tab, tabs, dispatch, active } = this.props;
    let promise;

    if (active) {
      const indexOfTab = _.findIndex(tabs, el => el.id === tab.id)
      const newTab = _.get(tabs, `[${indexOfTab + 1}]`) || _.get(tabs, `[${indexOfTab - 1}]`);
      const newPath = _.get(newTab, 'link', ACTIVE_SIGNAL_PATH);
      promise = dispatch(push(newPath));
    } else {
      promise = Promise.resolve();
    }

    promise
      .then(() => dispatch(appActions.removeTab(tab.id)))
      .then(() => { if (tab.formName) return dispatch(destroy(tab.formName)); });
  }

  render() {
    return (
      <button className='tab-close-btn' onClick={this.closeTab}>
        <SVGInline cleanup svg={svg} className="close-svg clearfix" />
      </button>
    );
  }
}

const TabClose = connect()(UnconnectedTabClose);

function Tab({ tab, tabs, active }){
  const classNames = cn({ closeable: tab.closeable });

  return (
    <li>
      <Link activeClassName="active" to={tab.link} className={classNames}>
        {tab.label}
        {tab.closeable ? <TabClose {...{ tab, tabs, active }} /> : undefined }
      </Link>
    </li>
  );
}

function Tabs({ tabs, currentRoute, router }) {
  const tabList = _.map(tabs, tab => {
    return (
      <Tab
        key={tab.id}
        active={router.isActive({ path: tab.link })}
        {...{ tab, tabs }}
      />
    );
  });

  return (
    <div className="container-fluid">
      <div className="row">
        <div className="col-xs-12">
          <ul className="nav nav-tabs">{tabList}</ul>
        </div>
      </div>
    </div>
  );
}

export default withRouter(connect(state => ({
  tabs: state.app.dashboard.tabs,
  currentRoute: state.routing.locationBeforeTransitions.pathname,
}))(Tabs));
