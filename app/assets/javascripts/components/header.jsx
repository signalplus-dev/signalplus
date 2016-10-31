import React from 'react';
import { connect } from 'react-redux';
import _ from 'lodash';
import LogOutLink from 'components/logOutLink.jsx';
import AccountLink from 'components/accountLink.jsx';

function Header({ brandUserName }) {
  return (
    <nav className="navbar navbar-static-top" role="navigation">
      {/* Brand and toggle get grouped for better mobile display */}
      <div className="container-fluid">
        <div className="row">
          <div className="col-xs-12">
            <div className="navbar-header">
              <button
                className="navbar-toggle"
                data-target="#navbarCollapse"
                data-toggle="collapse"
                type="button"
              >
                <span className="sr-only">Toggle navigation</span>
                <span className="icon-bar" />
                <span className="icon-bar" />
                <span className="icon-bar" />
              </button>
              <a href="/" className="navbar-brand">
                <img src={window.__IMAGE_ASSETS__.logoSignalplusPinkPng} alt="SignalPlus +" width="140" height="20" />
              </a>
            </div>
            <div id="navbarCollapse" className="collapse navbar-collapse">
              <ul className="nav navbar-nav navbar-right">
                <li><a href="/support">SUPPORT</a></li>
                <li className="dropdown-open">
                  <a className="dropdown-toggle header-cta" data-toggle="dropdown" role="button">
                    {`@${brandUserName}`}
                    <span className="caret" />
                  </a>
                  <ul className="dropdown-menu">
                    <li><AccountLink /></li>
                    <li><LogOutLink /></li>
                  </ul>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}

export default connect(state => ({
  brandUserName: _.get(state, 'models.brand.data.user_name'),
}))(Header);
