import cookies from 'browser-cookies';
import _ from 'lodash';
import { TA_KEY, SESSION_KEY } from 'util/cookieKeys';

const HEADER_AT_KEY = 'access-token';
const HEADER_CL_KEY = 'client';
const HEADER_EXPIRY_KEY = 'expiry';
export const HEADER_UID_KEY = 'uid';
export const HEADER_CSRF_KEY = 'X-CSRF-TOKEN';
let cl;

export function getTA() {
  try {
    const cookie = cookies.get(TA_KEY);
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
  setTACookie({
    'token-type':   'Bearer',
    'access-token': response.headers.get(HEADER_AT_KEY),
    client:         response.headers.get(HEADER_CL_KEY),
    uid:            response.headers.get(HEADER_UID_KEY),
    expiry:         response.headers.get(HEADER_EXPIRY_KEY),
  });
}

function setTACookie(ta) {
  const cookieValue = btoa(JSON.stringify(ta));
  cookies.set(TA_KEY, cookieValue);
}

export function changeUid(uid) {
  setTACookie({
    ...getTA(),
    uid,
  });
}

export function clearTA() {
  return new Promise((resolve, reject) => {
    try {
      cookies.erase(TA_KEY);
      resolve();
    } catch (err) {
      reject();
    }
  });
}

export function clearSession() {
  return new Promise((resolve, reject) => {
    try {
      cookies.erase(SESSION_KEY);
      resolve();
    } catch (err) {
      reject();
    }
  });
}

export function clearRackSession() {
  return new Promise((resolve, reject) => {
    try {
      cookies.erase('rack.session');
      resolve();
    } catch (err) {
      reject();
    }
  });
}

export function hasToken() {
  return !_.isEmpty(getTA());
}

export function getAT() {
  const metaTagCsrf = document.querySelectorAll('[name=csrf-token]')[0];
  return metaTagCsrf ? metaTagCsrf.content : metaTagCsrf;
}
