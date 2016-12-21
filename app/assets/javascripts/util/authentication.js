import cookies from 'cookie-monster';
import _ from 'lodash';
import { TA_KEY } from 'util/cookieKeys';

const HEADER_AT_KEY = 'access-token';
const HEADER_CL_KEY = 'client';
const HEADER_EXPIRY_KEY = 'expiry';
export const HEADER_UID_KEY = 'uid';
let cl;

export function getTA() {
  try {
    const cookie = cookies.getItem(TA_KEY);
    if (!cookie) return {};

    return JSON.parse(atob(cookie));
  } catch (err) {
    console.log(err);
    return {};
  }
}

export const baseHeaders = () => ({
  'Accept':       'application/json',
  'Content-Type': 'application/json',
});

export const requestHeaders = () => ({
  ...baseHeaders(),
  ...getTA(),
});

export function setTA(response) {
  const expiry = response.headers.get(HEADER_EXPIRY_KEY);
  cl = response.headers.get(HEADER_CL_KEY);

  const ta = {
    'access-token': response.headers.get(HEADER_AT_KEY),
    'token-type':   'Bearer',
    client:         cl,
    uid:            response.headers.get(HEADER_UID_KEY),
    expiry,
  };

  const cookieValue = btoa(JSON.stringify(ta));
  cookies.setItem(TA_KEY, cookieValue);
}

export function clearTA() {
  cookies.removeItem(TA_KEY);
}

export function hasToken() {
  return !_.isEmpty(getTA());
}

export function getAT() {
  const metaTagCsrf = document.querySelectorAll('[name=csrf-token]')[0];
  return metaTagCsrf ? metaTagCsrf.content : metaTagCsrf;
}
