import React from 'react';
import { Field } from 'redux-form';
import cn from 'classnames';

function Checkbox({
  input,
  valid,
  visited,
  active,
  meta: { error, touched },
  label,
  labelDescription,
  className,
  ...props,
}) {
  const classes = cn({
    checkbox: true,
    [className]: className,
  });

  return (
    <label className={classes}>
      <input {...input} type='checkbox' />
      <div>
        <div>{label}</div>
        <div className="labelDescription">{labelDescription}</div>
        {touched && error && <span className='input-form-error'>{error}</span>}
      </div>
    </label>
  );
}

export default function DecoratedCheckbox(props) {
  return <Field {...props} type="checkbox" component={Checkbox} />;
}
