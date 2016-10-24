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
      touched,
      valid,
      visited,
      active,
      meta,
      ...props,
    } = this.props;

    return (
      <div className='tz-dropdown'>
        <TimezonePicker
          {...props}
          value={input.value}
          absolute={false}
          placeholder='Select timezone...'
          onChange={this.onChange}
        />
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
