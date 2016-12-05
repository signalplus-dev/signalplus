
import React from 'react'


export default signalValidation = (values) => {
  const errors = {};

  if (!values.name) {
    errors.name = 'Hashtag required'
  } else if (values.name.indexOf(' ') >= 0) {
    errors.name = 'Your hashtag cannot contain a space!'
  } else if (values.name.indexOf('#') >= 0) {
    errors.name = 'Please input your hashtag without #'
  }
  if (!values.default_response) {
    errors.email = 'Required'
  } else if (values.default_response.length > 140) {
    errors.default_response = 'Your tweet cannot be longer than 140 characters'
  }
  if (!values.repeat_response) {
    errors.repeat_response = 'Required'
  } else if (values.repeat_response.length > 140) {
    errors.repeat_response = 'tweet cannot be longer than 140 characters'
  }

  return errors
}


// export default signalValidation = (values) => {
//   const errors = {};

//   if (!values.name) {
//     errors.name = 'Hashtag required'
//   } else if (values.name.indexOf(' ') >= 0) {
//     errors.name = 'Your hashtag cannot contain a space!'
//   } else if (values.name.indexOf('#') >= 0) {
//     errors.name = 'Please input your hashtag without #'
//   }
//   if (!values.default_response) {
//     errors.email = 'Required'
//   } else if (values.default_response.length > 140) {
//     errors.default_response = 'Your tweet cannot be longer than 140 characters'
//   }
//   if (!values.repeat_response) {
//     errors.repeat_response = 'Required'
//   } else if (values.repeat_response.length > 140) {
//     errors.repeat_response = 'tweet cannot be longer than 140 characters'
//   }

//   return errors
// }
