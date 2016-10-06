import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link, browserHistory } from 'react-router';
import { Button } from 'react-bootstrap';
import _ from 'lodash';
import EditMenuItem from 'components/contentPanel/editMenuItem.jsx';
import { actions as appActions } from 'redux/modules/app.js';
import { deleteListenSignalData } from 'redux/modules/models/listenSignals.js';

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
    this.deleteSignal = this.deleteSignal.bind(this);
  }

  renderMenuItems(menuItems) {
    return _.map(menuItems, (menu) => {
      return <MenuItem key={menu.label} menu={menu}/>;
    });
  }

  deleteSignal() {
    const { dispatch, signal, tabId } = this.props;
    if (signal.id) {
      dispatch(deleteListenSignalData(signal));
      dispatch(appActions.removeTab(tabId)).then(() => {
        browserHistory.push(ACTIVE_SIGNAL_PATH);
      });
    };
  }

  showDelete() {
    if (this.props.signal) {
      return (
        <div className='sidebar-btns'>
          <Button className='delete-btn' onClick={this.deleteSignal}>
            DELETE SIGNAL
          </Button>
        </div>
      );
    }
  }

  render() {
    const { menuItems } = this.props; 

    return (
      <div className='col-md-2 sidebar'>
        <ul className='sidebar-menus'>
          {this.renderMenuItems(menuItems)}
        </ul>
        {this.showDelete()}
      </div>
    );
  }
}

export default connect()(Sidebar);
