import React, { Component } from 'react';
import logOut from 'util/logOut.js';
import endpoints from 'util/endpoints.js';


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

      logOut()
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
        ref="link"
        href={endpoints.REGULAR_SIGN_OUT}
        rel="nofollow"
        data-method="delete"
        onClick={this.handleClick}
      >
        Log Out
      </a>
    );
  }
}

export default LogOutLink;
