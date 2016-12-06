import React, { PureComponent } from 'react'
import { Field } from 'redux-form';
import { DateField } from 'react-date-picker'

class Calendar extends PureComponent {
  constructor(props) {
    super(props)
    this.onChange = this.onChange.bind(this);
    this.state = {date: this.props.date};
  }

  onChange(e) {
    const key = 'expirationDate'
    this.setState({date: e});
  }

  render() {
    const {
      input,
      touched,
      valid,
      meta,
      ...props,
    } = this.props;

    return (
      <DateField
        dateFormat="YYYY-MM-DD"
        defaultValue={this.state.date}
        onChange={this.onChange}
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
