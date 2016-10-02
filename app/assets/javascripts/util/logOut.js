import cookies from 'util/cookies.js';
import restInterface from 'util/restInterface.js';
import endpoints from 'util/endpoints.js';
import { TA_KEY } from 'util/cookieKeys.js';

export default function logOut() {
  return  restInterface
            .deleteRequest(endpoints.TOKEN_SIGN_OUT)
            .then(response => cookies.removeItem(TA_KEY, '/'));
};
