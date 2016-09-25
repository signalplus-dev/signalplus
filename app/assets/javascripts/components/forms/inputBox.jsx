import React from 'react';
import { Field } from 'redux-form';
import { FormControl } from 'react-bootstrap';

function InputBox({
  input,
  touched,
  valid,
  visited,
  active,
  meta,
  ...props,
  }) {
  const { textArea, ...otherInputProps } = input;

  return (
    <div className='input-box'>
      <FormControl {...props} {...otherInputProps} />
    </div>
  );
}

export default function DecoratedInputBox({ FieldType = Field, ...props}) {
  return (
    <FieldType
      {...props}
      component={InputBox}
    />
  );
}
