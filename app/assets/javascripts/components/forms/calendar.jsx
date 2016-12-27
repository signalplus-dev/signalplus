import React, { Component } from 'react'
import _ from 'lodash';
import { Field } from 'redux-form';
import { DateField } from 'react-date-picker'
import moment from 'moment';

class Calendar extends Component {
  componentDidMount() {
    const { input } = this.props;

    const date = input.value ? moment(input.value) : moment().add(7, 'day');
    input.onChange(date);
  }

  render() {
    const {
      input,
      valid,
      meta: { touched, error},
      ...props,
    } = this.props;

    const date = moment(input.value);
    const inputProps = _.pick(input, ['onBlur', 'onChange', 'onDragStart', 'onDrop', 'onFocus']);

    return (
      <div className='calendar-wrapper'>
        <DateField
          dateFormat="YYYY-MM-DD"
          defaultValue={date.format('YYYY-MM-DD')}
          {...inputProps}
        />
        <div>
          {touched && error && <span className='input-form-error'>{error}</span>}
        </div>
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
