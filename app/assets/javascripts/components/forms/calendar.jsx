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

    const inputValue = moment(input.value) || moment();

    return (
      <DateField
        dateFormat="YYYY-MM-DD"
        defaultValue={inputValue.format('YYYY-MM-DD')}
        onChange={input.onChange}
      />
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
