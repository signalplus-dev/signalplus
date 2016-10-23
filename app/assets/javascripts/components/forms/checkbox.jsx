import React from 'react';
import { Field } from 'redux-form';

function Checkbox({
  input,
  touched,
  valid,
  visited,
  active,
  meta,
  ...props,
}) {
  return (
    <label>
      <input {...input} type='checkbox' />
      {props.label}
    </label>
  );
}

export default function DecoratedCheckbox(props) {
  return <Field {...props} type="checkbox" component={Checkbox} />;
}
