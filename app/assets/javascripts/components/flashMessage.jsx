import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import cn from 'classnames';
import SignalIcon from 'components/links/signal_icon.jsx';
import { actions } from 'redux/modules/app/index.js';


class FlashMessage extends PureComponent {
  constructor(props) {
    super(props);
    this.handleDismiss = this.handleDismiss.bind(this);
  }

  handleDismiss() {
    this.props.dispatch(actions.dismissFlashMessage());
  }

  render() {
    const { flashMessage } = this.props;
    const flashMessageClasses = cn(
      'flash-messages',
      flashMessage.type,
      { dismissed: flashMessage.dismissed }
    );

    return (
      <div className={flashMessageClasses}>
        <SignalIcon className="bell" type="bell" />
        <div className="message">
          {flashMessage.message}
        </div>

        <a className="close" onClick={this.handleDismiss}>
          <SignalIcon type="close" />
        </a>
      </div>
    );
  }
}

export default connect(state => ({
  flashMessage: state.app.flashMessage,
}))(FlashMessage);
