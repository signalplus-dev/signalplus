import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import TimezonePicker from 'react-bootstrap-timezone-picker';

const TIMEZONES = {
  '(GMT-08:00) Pacific Time': 'America/Los_Angeles',
  '(GMT-07:00) Mountain Time': 'America/Denver',
  '(GMT-06:00) Central Time': 'America/Chicago',
  '(GMT-05:00) Eastern Time': 'America/New_York',
};

class Dropdown extends PureComponent {
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
          absolute={false}
          defaultValue='Europe/Moscow'
          placeholder='Select timezone...'
          onChange={this.onChange}
          timezones={TIMEZONES}
        />
      </div>
    );
  }
}

export default function DecoratedDropdown(props) {
  return (
    <Field
      {...props}
      component={Dropdown}
    />
  );
}
