import React from 'react';
import moment from 'moment';
import { Link } from 'react-router';

export default function CurrentPlanMenuItem({ menu, subscription }) {
  return (
    <li className="uctext">
      <Link
        {...menu.linkProps}
        activeClassName="active"
        className="currentPlanMenuItem"
      >
      {menu.label}
      <p className="subscription-name">
        {subscription.name}
      </p>
      <p className="subscription-month">{moment().format('MMM YYYY')}</p><br/>
      </Link>
    </li>
  );
}
