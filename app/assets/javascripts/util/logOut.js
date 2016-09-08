import cookies from './cookies.js';
import restInterface from './restInterface.js';
import endpoints from './endpoints.js';
import { TA_KEY } from './cookieKeys.js';

export default function logOut() {
  return  restInterface
            .deleteRequest(endpoints.TOKEN_SIGN_OUT)
            .then(response => cookies.removeItem(TA_KEY, '/'));
};
