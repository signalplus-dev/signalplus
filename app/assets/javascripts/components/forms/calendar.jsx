import React, { PureComponent } from 'react'
import { Field } from 'redux-form';
import { DateField } from 'react-date-picker'

class Calendar extends PureComponent {
  render() {
    const {
      input,
      valid,
      meta: { touched, error} ,
      ...props,
    } = this.props;

    return (
      <div>
        <DateField
          dateFormat="YYYY-MM-DD"
          defaultValue={input.value}
          onChange={input.onChange}
        />
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
