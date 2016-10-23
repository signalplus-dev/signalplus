import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import TimezonePicker from 'react-bootstrap-timezone-picker';
import _ from 'lodash';

const TIMEZONES = {
  '(GMT-08:00) America/Los_Angeles': 'America/Los_Angeles',
  '(GMT-07:00) America/Denver': 'America/Denver',
  '(GMT-06:00) America/Chicago': 'America/Chicago',
  '(GMT-05:00) America/New_York': 'America/New_York',
};

class TimezoneDropdown extends PureComponent {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(e) {
    this.props.input.onChange(e);
  }

  findTimezoneLabel(tz) {
    return _.findKey(TIMEZONES, (tzLabel) => (tzLabel.indexOf(tz)));
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
          defaultValue={this.findTimezoneLabel(input.value)}
          absolute={false}
          placeholder='Select timezone...'
          onChange={this.onChange}
          timezones={TIMEZONES}
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
