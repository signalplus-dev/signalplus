import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import moment from 'moment-timezone';
import TimezonePicker from 'react-bootstrap-timezone-picker';
import _ from 'lodash';

const ACTIVE_TIMEZONE_LIST = [
  'America/Los_Angeles', 
  'America/Denver', 
  'America/Chicago',
  'America/New_York',
]

const getActiveTimezone = () => {
  const timezones = moment.tz.names();
  const activeTimezones = {};

  timezones.map(function(tz) {
    if (ACTIVE_TIMEZONE_LIST.includes(tz)) {
      const label = " (GMT" + moment.tz(tz).format('Z')+") " + tz;
      activeTimezones[label] = tz;
    }
  });

  return activeTimezones;
} 

class TimezoneDropdown extends PureComponent {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(e) {
    this.props.input.onChange(e);
  }

  findTimezoneLabel(activeTimezones, tz) {
    return _.findKey(activeTimezones, (tzLabel) => (tzLabel.indexOf(tz)));
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
    const activeTimezones = getActiveTimezone();

    return (
      <div className='tz-dropdown'>
        <TimezonePicker
          {...props}
          defaultValue={this.findTimezoneLabel(activeTimezones, input.value)}
          absolute={false}
          placeholder='Select timezone...'
          onChange={this.onChange}
          timezones={activeTimezones}
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
