import React from 'react';

const ACCOUNT_PATHNAME = '/dashboard/account';

export default function AccountLink() {
  return (
    <a href={ACCOUNT_PATHNAME}>
      Account
    </a>
  );
}

