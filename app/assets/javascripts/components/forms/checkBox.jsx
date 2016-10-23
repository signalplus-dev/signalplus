import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import { Checkbox } from 'react-bootstrap';

class CheckBox extends PureComponent {
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
      <label>
        <input 
          {...input}
          type='checkbox'
          ref='checkbox'
        >
        </input>
        {this.props.label}
      </label>
    );
  }
}

export default function DecoratedCheckBox(props) {
  return (
    <Field
      {...props}
      component={CheckBox}
    />
  );
}
