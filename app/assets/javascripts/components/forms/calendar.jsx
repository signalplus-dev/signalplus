import React, { PureComponent } from 'react'
import { Field } from 'redux-form';
import { DateField } from 'react-date-picker'
import moment from 'moment';

class Calendar extends PureComponent {
  render() {
    const {
      input,
      valid,
      meta: { touched, error} ,
      ...props,
    } = this.props;

    const date = input.value ? moment(input.value) : moment().add(7, 'day');

    return (
      <div className='calendar-wrapper'>
        <DateField
          forceValidDate
          dateFormat="YYYY-MM-DD"
          defaultValue={date.format('YYYY-MM-DD')}
          onChange={input.onChange}
        />
        { touched && error && <span className='input-form-error'>{error}</span> }
      </div>
    );
  }
}

export default function DecoratedCalendar(props) {
  return (
    <Field
      {...props}
      component={Calendar}
    />
  );
}
