import React from 'react'

export function signalInputValidation({ name, default_response, repeat_response }) {
  const errors = {};

  if (!name) {
    errors.name = 'Hashtag required.'
  } else if (name.indexOf(' ') >= 0) {
    errors.name = 'Your hashtag cannot contain a space.'
  } else if (name.indexOf('#') >= 0) {
    errors.name = 'Please put your hashtag name without #.'
  }

  if (!default_response) {
    errors.default_response = 'Default response required.'
  } else if (default_response.length > 140) {
    errors.default_response = 'Your tweet response cannot exceed 140 characters.'
  }

  if (!repeat_response) {
    errors.repeat_response = 'Repeat respose reqired.'
  } else if (repeat_response.length > 140) {
    errors.repeat_response = 'Your tweet response cannot exceed 140 characters.'
  }

  return errors
}

export function accountInputValidation({ email, tz }) {
  const errors = {};

  if (!email) {
    errors.email = 'Email Required'
  } else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(email)) {
    errors.email = 'Invalid email address'
  }

  if (!tz) {
    errors.tz = 'Timezone required.'
  }

  return errors
}
