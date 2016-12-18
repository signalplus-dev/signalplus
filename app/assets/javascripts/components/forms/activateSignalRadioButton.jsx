import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import { Field } from 'redux-form';
import cn from 'classnames';
import { TOGGLE_SIGNAL } from 'components/modals/modalConstants';
import { actions as appActions } from 'redux/modules/app/index.js';
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

    dispatch(appActions.showModal({
      modalType: TOGGLE_SIGNAL,
      modalProps: {
        signalName: signal.name,
        activate: !signal.active,
        onConfirm: this.toggleSignalState,
      },
    }));
  }

  toggleSignalState() {
    const { dispatch, signal: { active, id } } = this.props;
    const form = { active: !active };
    this.refs.checkbox.click();
    dispatch(updateListenSignalData(form, id, 'PATCH'));
  }

  render () {
    const {
      input,
      touched,
      valid,
      visited,
      active,
      meta,
      signal,
      ...props,
    } = this.props;

    const labelClasses = cn({
      toggleSignal: true,
      newSignal: !signal.id,
      activeSignal: input.checked,
    });

    return (
      <label
        htmlFor="activeSignalRadio"
        onClick={this.handleClick}
        className={labelClasses}
      >
        <input
          {...input}
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

const ConnectedActivateSignalRadioButton = connect()(ActivateSignalRadioButton);

export default function DecoratedRadioButton(props) {
  return (
    <Field
      {...props}
      name="active"
      type="checkbox"
      component={ConnectedActivateSignalRadioButton}
    />
  );
}
