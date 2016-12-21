import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import TimezonePicker from 'react-bootstrap-timezone-picker';

class TimezoneDropdown extends PureComponent {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(e) {
    this.props.input.onChange(e);
  }

  render() {
    const {
      input,
      valid,
      visited,
      active,
      meta: { error, touched },
      ...props,
    } = this.props;

    return (
      <div className='tz-dropdown'>
        <TimezonePicker
          {...props}
          value={input.value}
          absolute={false}
          placeholder='Select timezone...'
          onChange={input.onChange}
          onBlur={input.onBlur}
          onFocus={input.onFocus}
          onKeyDown={input.onKeyDown}
        />
        {touched && error && <span className='input-form-error'>{error}</span>}
      </div>
    );
  }
}

export default function DecoratedTimezoneDropdown(props) {
  return (
    <Field
      {...props}
      component={TimezoneDropdown}
    />
  );
}
