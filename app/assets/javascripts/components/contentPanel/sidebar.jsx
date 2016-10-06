import React from 'react';
import { Link } from 'react-router';
import _ from 'lodash';
import EditMenuItem from 'components/contentPanel/editMenuItem.jsx';

function MenuItem({ menu }) {
  return (
    <li className="uctext">
      <Link
        {...menu.linkProps}
        activeClassName="active"
      >
        {menu.label}
      </Link>
    </li>
  );
}

function renderMenuItems(menuItems, signal) {
  return _.map(menuItems, (menu) => {
    if (menu.label === 'Edit') {
      return <EditMenuItem key={menu.label} {...{ menu, signal }} />;
    }

    return <MenuItem key={menu.label} menu={menu}/>;
  });
}

export default function Sidebar({ menuItems, signal }) {
  return (
    <div className='col-xs-2 sidebar'>
      <ul className='sidebar-menus'>
        {renderMenuItems(menuItems, signal)}
      </ul>
    </div>
  );
}
