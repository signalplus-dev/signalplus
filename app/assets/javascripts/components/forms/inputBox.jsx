import React from 'react';
import { Field } from 'redux-form';
import { FormControl } from 'react-bootstrap';

function InputBox({
  input,
  valid,
  visited,
  active,
  meta: { touched, error} ,
  ...props,
  }) {
  const { textArea, ...otherInputProps } = input;

  return (
    <div className='input-box'>
      <FormControl {...props} {...otherInputProps} />
      { touched && error &&
        <span className='input-form-error'>{error}</span>
      }
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
