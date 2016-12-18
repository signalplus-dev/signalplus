import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link, browserHistory } from 'react-router';
import { Button } from 'react-bootstrap';
import _ from 'lodash';
import EditMenuItem from 'components/contentPanel/editMenuItem.jsx';
import { actions as appActions } from 'redux/modules/app/index.js';
import { deleteListenSignalData } from 'redux/modules/models/listenSignals.js';
import { DELETE_SIGNAL } from 'components/modals/modalConstants';

const ACTIVE_SIGNAL_PATH = '/dashboard/signals/active';

export function MenuItem({ menu }) {
  return (
    <li className="uctext">
      <Link {...menu.linkProps} activeClassName="active">
        {menu.label}
      </Link>
    </li>
  );
}

class Sidebar extends Component {
  constructor(props) {
    super(props);
    this.confirmDelete = this.confirmDelete.bind(this);
  }

  renderMenuItems(menuItems, signal) {
    return _.map(menuItems, (menu) => {
      if (menu.label === 'Edit') {
        return <EditMenuItem key={menu.label} {...{ menu, signal }} />;
      }

      return <MenuItem key={menu.label} menu={menu}/>;
    });
  }

  confirmDelete() {
    const { dispatch, signal, tabId} = this.props;

    dispatch(appActions.showModal({
      modalType: DELETE_SIGNAL,
      modalProps: {
        signal: signal,
        tabId: tabId,
      }
    }));
  }

  showDelete() {
    if (this.props.signal.id) {
      return (
        <div className='sidebar-btns'>
          <Button className='delete-btn' onClick={this.confirmDelete}>
            DELETE SIGNAL
          </Button>
        </div>
      );
    }
  }

  render() {
    const { menuItems, signal } = this.props;

    return (
      <div className='col-xs-2 sidebar'>
        <ul className='sidebar-menus'>
          {this.renderMenuItems(menuItems, signal)}
        </ul>
        {this.showDelete()}
      </div>
    );
  }
}

export default connect()(Sidebar);
