import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import cn from 'classnames';
import { TOGGLE_SIGNAL } from 'components/modals/modalConstants';
import { actions as appActions } from 'redux/modules/app/index';
import { updateListenSignalData } from 'redux/modules/models/listenSignals';

class ActivateSignalRadioButton extends PureComponent {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
    this.toggleSignalState = this.toggleSignalState.bind(this);
  }

  handleClick(event) {
    event.preventDefault();
    event.stopPropagation();

    const { dispatch, signal } = this.props;

    if (signal.id) {
      dispatch(appActions.showModal({
        modalType: TOGGLE_SIGNAL,
        modalProps: {
          signalName: signal.name,
          activate: !signal.active,
          onConfirm: this.toggleSignalState,
        },
      }));
    }
  }

  toggleSignalState() {
    const { dispatch, signal: { active, id } } = this.props;
    const form = { active: !active };
    this.refs.checkbox.click();
    dispatch(updateListenSignalData(form, id, 'PATCH'));
  }

  render () {
    const { signal } = this.props;

    const labelClasses = cn({
      toggleSignal: true,
      newSignal: !signal.id,
      activeSignal: signal.active,
    });

    return (
      <label
        htmlFor="activeSignalRadio"
        onClick={this.handleClick}
        className={labelClasses}
      >
        <input
          id="activeSignalRadio"
          ref="checkbox"
          type="checkbox"
          className="activeSignalRadio"
          disabled={!signal.id}
        />
        <div className="toggleKnob"></div>
      </label>
    );
  }
}

export default connect()(ActivateSignalRadioButton);
