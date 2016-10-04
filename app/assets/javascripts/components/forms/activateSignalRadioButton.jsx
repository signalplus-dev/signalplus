import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import cn from 'classnames';

class ActivateSignalRadioButton extends PureComponent {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(event) {
    console.log('lasdjlskj');
    event.preventDefault();
    event.stopPropagation();
    this.refs.checkbox.click();
  }

  render () {
    const {
      input,
      touched,
      valid,
      visited,
      active,
      meta,
      ...props,
    } = this.props;

    const labelClasses = cn(
      'toggleSignal',
      { activeSignal: input.checked }
    );

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
        />
        <div className="toggleKnob"></div>
      </label>
    );
  }
}

export default function DecoratedRadioButton(props) {
  return (
    <Field
      {...props}
      name="active"
      type="checkbox"
      component={ActivateSignalRadioButton}
    />
  );
}