import React from 'react';
import { Link } from 'react-router';
import _ from 'lodash';

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

function renderMenuItems(menuItems) {
  return _.map(menuItems, (menu) => {
    return <MenuItem key={menu.label} menu={menu}/>;
  });
}

export default function Sidebar({ menuItems }) {
  return (
    <div className='col-md-2 sidebar'>
      <ul className='sidebar-menus'>
        {renderMenuItems(menuItems)}
      </ul>
    </div>
  );
}
