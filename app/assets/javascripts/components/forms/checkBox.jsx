import React, { PureComponent } from 'react';
import { Field } from 'redux-form';
import { Checkbox } from 'react-bootstrap';

function CheckBox({
  ...props
  }) {
  return (
    <Checkbox 
      {...props}
      checked={props.input.value} 
    >
      {props.label}
    </Checkbox>
  );
}

export default function DecoratedCheckBox(props) {
  return (
    <Field
      {...props}
      component={CheckBox}
    />
  );
}
