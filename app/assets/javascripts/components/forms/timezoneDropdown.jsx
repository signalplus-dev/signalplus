import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import moment from 'moment-timezone';
import TimezonePicker from 'react-bootstrap-timezone-picker';
import _ from 'lodash';

const getTimezoneWithLabels = () => {
  const timezones = moment.tz.names();
  const timezonesWithLabels= {};

  timezones.map(function(tz) {
    const label = " (GMT" + moment.tz(tz).format('Z')+") " + tz;
    timezonesWithLabels[label] = tz;
  });

  return timezonesWithLabels;
}

class TimezoneDropdown extends PureComponent {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(e) {
    this.props.input.onChange(e);
  }

  findTimezoneLabel(timezones, tz) {
    return _.findKey(timezones, (tzLabel) => (tzLabel.indexOf(tz)));
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
    const timezones = getTimezoneWithLabels();

    return (
      <div className='tz-dropdown'>
        <TimezonePicker
          {...props}
          defaultValue={this.findTimezoneLabel(timezones, input.value)}
          absolute={false}
          placeholder='Select timezone...'
          onChange={this.onChange}
          timezones={timezones}
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
