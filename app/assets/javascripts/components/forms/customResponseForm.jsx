import React, { Component } from 'react';
import InputBox from 'components/forms/inputBox.jsx';
import Calendar from 'components/forms/calendar.jsx';
import _ from 'lodash';

function renderFields({ fields, meta: { touched, error } }) {
  return fields.map((response, index) => {
    return (
      <div className='response-edit-box' key={index}>
        <div className='response-text'>
          <h5>Response</h5>
          <span className='custom-response-box-label'>
            <p>Expires on:</p>
            <Calendar
              name={`${response}.expiration_date`}
              date='2016-02-03'
            />
          </span>
        </div>
        <InputBox
          name={`${response}.text`}
          placeholder="Type your response here, add website links too"
          componentClass="textarea"
        />
        { touched && error && <span className='input-form-error'>{error}</span> }
        <a onClick={()=> fields.remove(index)} className='delete-custom-response-btn'>
          delete
        </a>
      </div>
    );
  });
}

export default function CustomResponseForm({ ...props }) {
  return <div>{renderFields(props)}</div>;
}
