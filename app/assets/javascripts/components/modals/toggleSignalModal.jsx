import React from 'react';

import ConfirmModal from 'components/modals/confirmModal';

export default function ToggleSignalModal({
   display,
   signalName,
   activate,
   onConfirm,
}) {
  const activateText = activate ? 'activate' : 'inactivate';
  const header = `Are you sure you want to ${activateText} signal #${signalName}?`
  const body = 'Click on the Promote tab to advertise your signal to your followers.'

  return (
    <ConfirmModal
      display={display}
      onConfirm={onConfirm}
      header={header}
      body={body}
    />
  );
}
