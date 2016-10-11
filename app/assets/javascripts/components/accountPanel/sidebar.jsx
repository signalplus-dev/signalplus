import React, { Component } from 'react';
import _ from 'lodash';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { Button } from 'react-bootstrap';
import { actions as appActions } from 'redux/modules/app.js';

export default function MenuItem({ menu }) {
  return (
    <li className="uctext">
      <Link {...menu.linkProps} key={menu.label} activeClassName="active">
        {menu.label}
      </Link>
    </li>
  );
}

class Sidebar extends Component {
  constructor(props) {
    super(props);
    console.log(props)
  }

  closeAccount() {
    const { dispatch, tabId } = this.props;
  }

  renderMenuItems() {
  const basePath = '/dashboard/account';
  const menuItems = [
    {
      label: 'Details',
      linkProps: {
        to: basePath,
        onlyActiveOnIndex: true,
      },
    },
    {
      label: 'Current Plan',
      linkProps: {
        to: `${basePath}/current_plan`,
        onlyActiveOnIndex: false,
      },
    },
  ];

  const x = _.map(menuItems, (menu) => {
    return (
      <MenuItem key={menu.label} menu={menu}/>
    );
  });
  return x
}

  render() {
    return (
      <div className='col-xs-2 sidebar'>
        <ul className='sidebar-menus'>
          { this.renderMenuItems() }
        </ul>
        <div className='sidebar-btns'>
          <Button className='close-account-btn' onClick={this.closeAccount}>
            CLOSE ACCOUNT
          </Button>
        </div>
      </div>
    );
  }
}

export default connect()(Sidebar);
