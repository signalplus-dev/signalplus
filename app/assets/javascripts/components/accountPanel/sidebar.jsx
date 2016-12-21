import React, { Component } from 'react';
import _ from 'lodash';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { Button } from 'react-bootstrap';
import { actions as appActions } from 'redux/modules/app/index';

// Components
import CurrentPlanMenuItem from 'components/accountPanel/currentPlanMenuItem';

function MenuItem({ menu }) {
  return (
    <li className="uctext">
      <Link {...menu.linkProps} key={menu.label} activeClassName="active">
        {menu.label}
      </Link>
    </li>
  );
}

class Sidebar extends Component {
  // TODO: Finish the close account action.
  closeAccount() {
    // Close account on click.
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

    return _.map(menuItems, (menu) => {
      if (menu.label === 'Current Plan') {
        return <CurrentPlanMenuItem
                  key={menu.label}
                  menu={menu}
                  subscription={this.props.subscription}
                />
      }

      return <MenuItem key={menu.label} menu={menu}/>
    });
  }

  renderButtons() {
    // Don't display the "CLOSE ACCOUNT" button for now
    if (false) {
      return (
        <div className='sidebar-btns'>
          <Button className='close-account-btn' onClick={this.closeAccount}>
            CLOSE ACCOUNT
          </Button>
        </div>
      );
    }

    return undefined;
  }

  render() {
    return (
      <div className='col-xs-2 sidebar'>
        <ul className='sidebar-menus'>
          {this.renderMenuItems()}
        </ul>
        {this.renderButtons()}
      </div>
    );
  }
}

export default connect(state => ({
  currentRoute: state.routing.locationBeforeTransitions.pathname,
  subscription: state.models.subscription.data,
}))(Sidebar);
