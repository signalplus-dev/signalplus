import React, { Component } from 'react';
import { connect } from 'react-redux';
import { logOut } from 'redux/utils';
import Endpoints from 'util/endpoints';


class LogOutLink extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
    this.state = {
      loggedOut: false,
    };
  }

  handleClick(event) {
    if (!this.state.loggedOut) {
      event.preventDefault();

      this.props.dispatch(logOut())
        .then((response) => {
          this.setState({ loggedOut: true });
          this.refs.link.click();
        })
        .catch(response => {
          console.log('SOME ERROR');
        });
    }
  }

  shouldComponentUpdate() {
    return false;
  }

  render() {
    return (
      <a
        id="js_logOutLink"
        href={Endpoints.REGULAR_SIGN_OUT}
        data-method="delete"
        ref="link"
        rel="nofollow"
        onClick={this.handleClick}
      >
        Log Out
      </a>
    );
  }
}

export default connect()(LogOutLink);
