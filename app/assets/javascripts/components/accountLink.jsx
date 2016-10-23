import React from 'react';
import { Link } from 'react-router';

const ACCOUNT_PATHNAME = '/dashboard/account';

export default function AccountLink() {
  return (
    <Link href={ACCOUNT_PATHNAME}>
      Account
    </Link>
  );
}

