import cookies from './cookies.js';
import Endpoints from  './endpoints.js';
import _ from 'lodash';
import 'whatwg-fetch';
import crypto from 'crypto-js';
import { Promise } from 'es6-promise';
import queryString from 'query-string';
import { TA_KEY } from './cookieKeys.js';

const HEADER_AT_KEY = 'access-token';
const HEADER_CL_KEY = 'client';
const HEADER_EXPIRY_KEY = 'expiry';
const HEADER_UID_KEY = 'uid';
const SALT = 'some_salt'
let cl;

function baseHeaders(csrfToken) {
  return {
    'Accept':       'application/json',
    'Content-Type': 'application/json',
    'X-CSRF-TOKEN': csrfToken,
  };
}

export default {
  refreshToken: function() {
    return fetch(Endpoints.REFRESH_TOKEN, {
      method:      'POST',
      credentials: 'same-origin',
      headers:     this.requestHeaders(),
    }).then(response => {
      if (response.status === 200) {
        this.setTA(response);
      }
    })
  },
  setTA: function(response) {
    const expiry = response.headers.get(HEADER_EXPIRY_KEY);
    cl = response.headers.get(HEADER_CL_KEY);

    const ta = {
      'access-token': response.headers.get(HEADER_AT_KEY),
      'token-type':   'Bearer',
      client:         cl,
      uid:            response.headers.get(HEADER_UID_KEY),
      expiry,
    };

    const cookieValue = crypto.AES.encrypt(JSON.stringify(ta), SALT).toString();
    cookies.setItem(TA_KEY, cookieValue, expiry, '/');
  },
  clearTA: function() {
    const cookie = cookies.removeItem(TA_KEY, '/');
  },
  hasToken: function() {
    return !_.isEmpty(this.getTA());
  },
  getTA: function() {
    try {
      const cookie = cookies.getItem(TA_KEY);
      if (!cookie) return {};

      return JSON.parse(
        crypto
          .AES
          .decrypt(cookie, SALT)
          .toString(crypto.enc.Utf8)
      );
    } catch(err) {
      console.log(err);
      return {};
    }
  },
  getAT: function() {
    return document.querySelectorAll('[name=csrf-token]')[0];
  },
  isTAExpired: function() {
    const expiry = parseInt(this.getTA().expiry || 0);
    return (expiry - 5) <= (new Date()).getTime() / 1000;
  },
  handleRequest: function(promise) {
    return new Promise((resolve, reject) => {
      if (this.isTAExpired()) {
        return this.refreshToken()
          .then(response => this._processRequest(promise, resolve, reject));
      } else {
        return this._processRequest(promise, resolve, reject);
      }
    }).catch(response => {
      console.log(response);
    });
  },
  _processRequest: function(promise, resolve, reject) {
    return promise.then(response => {
      if (response.status >= 400) {
        return reject(response);
      } else {
        return resolve(response);
      }
    }).catch(response => {
      console.log(response);
    });
  },
  requestHeaders: function() {
    return {
      ...baseHeaders(this.getAT().content),
      ...this.getTA(),
    };
  },
  /**
    * Interface for GET requests
    *
    * @param {String} path, path for the GET request
    * @param {Object} params, Extra query params for the GET request
    * @param {Object} addtionalHeaders, Extra headers to set on the request
    */
  getRequest: function(path, params = {}, additionalHeaders = {}) {
    let basePath = path;
    if (!_.isEmpty(params)) {
      basePath += `?${queryString.stringify(params)}`;
    }

    return this.handleRequest(
      fetch(basePath, {
        method:  'GET',
        headers: {
          ...this.requestHeaders(),
          ...additionalHeaders,
        },
      })
    );
  },
  /**
    * Interface for POST requests
    *
    *
    */
  postRequest: function(path, body = {}, additionalHeaders = {}) {
    return this.handleRequest(
      fetch(path, {
        method:  'POST',
        headers: {
          ...this.requestHeaders(),
          ...additionalHeaders,
        },
        body: JSON.stringify(body),
      })
    );
  },
  /**
    * Interface for PUT requests
    *
    *
    */
  putRequest: function(path, params = {}, body = {}, additionalHeaders = {}) {
    let basePath = path;
    basePath += `?${queryString.stringify(params)}`;

    return this.handleRequest(
      fetch(path, {
        method:  'PUT',
        headers: {
          ...this.requestHeaders(),
          ...additionalHeaders,
        },
        body: JSON.stringify(body),
      })
    );
  },
  /**
    * Interface for DELETE requests
    *
    *
    */
  deleteRequest: function(path, params = {}, additionalHeaders = {}) {
    let basePath = path;
    basePath += `?${queryString.stringify(params)}`;

    return this.handleRequest(
      fetch(basePath, {
        method:  'DELETE',
        headers: {
          ...this.requestHeaders(),
          ...additionalHeaders,
        },
      })
    );
  },
};
