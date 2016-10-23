import React from 'react';
import { Link } from 'react-router';

const ACCOUNT_PATHNAME = '/dashboard/account';

export default function AccountLink() {
  return (
    <Link to={ACCOUNT_PATHNAME}>
      Account
    </Link>
  );
}

