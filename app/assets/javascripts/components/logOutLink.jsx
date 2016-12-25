import React, { Component } from 'react';
import { connect } from 'react-redux';
import { apiLogOut } from 'redux/utils';
import { logOut } from 'redux/modules/app/authentication';
import Endpoints from 'util/endpoints';

class LogOutLink extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(event) {
    event.preventDefault();
    const { dispatch } = this.props;

    dispatch(apiLogOut)
      .then(() => dispatch(logOut))
      .catch(response => {
        console.log('SOME ERROR');
      });
  }

  shouldComponentUpdate() {
    return false;
  }

  render() {
    return (
      <a onClick={this.handleClick} style={{ cursor: 'pointer' }}>
        Log Out
      </a>
    );
  }
}

export default connect()(LogOutLink);
